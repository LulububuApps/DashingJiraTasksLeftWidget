#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'openssl'

# Config
jira_board_id      = ""
jira_username      = ""
jira_password      = ""
jira_url           = ""

def getTasksLeftForActiveSprint (jira_board_id, jira_username, jira_password, jira_url)
	tasksLeft = 0
	
	sprintUri = URI("https://#{jira_url}/rest/agile/1.0/board/#{jira_board_id}/sprint?state=active")

	puts "... requesting #{sprintUri.request_uri}"
	
	Net::HTTP.start(sprintUri.host, sprintUri.port,
		:use_ssl     => sprintUri.scheme == 'https', 
		:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

		request = Net::HTTP::Get.new sprintUri.request_uri
		request.basic_auth jira_username, jira_password

		sprintResponse     = http.request request
		sprintResponseJson = JSON.parse(sprintResponse.body)

		sprintId  = sprintResponseJson['values'][0]['id'];  
		issues    = []
		startAt   = 0;
		
		loop do 
		
			issuesUri = URI("https://#{jira_url}/rest/agile/1.0/sprint/#{sprintId}/issue?startAt=#{startAt}")
			hadIssues = true
		  
			puts "... requesting #{issuesUri.request_uri}"
		  
			Net::HTTP.start(issuesUri.host, issuesUri.port,
				:use_ssl     => issuesUri.scheme == 'https', 
				:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

				request = Net::HTTP::Get.new issuesUri.request_uri
				request.basic_auth jira_username, jira_password

				issuesResponse = http.request request
				issuesResponseJson = JSON.parse(issuesResponse.body)

				newIssues = issuesResponseJson['issues'];
				
				if newIssues.length > 0
					issues = issues + newIssues
				else
				    hadIssues = false
				end
			end
			
		    startAt = startAt + 50
		
		    break if !hadIssues
		end 
		
		issues.each { |issue|
			fields = issue['fields'];

			if (!fields['resolutiondate'] || fields['resolutiondate'].length == 0)
			    tasksLeft = tasksLeft + 1
			end
		}
	end
 
	puts "... tasks left: #{tasksLeft}"
 
	return tasksLeft
end

#getTasksLeftForActiveSprint(jira_board_id, jira_username, jira_password, jira_url)

SCHEDULER.every '5m', :first_in => 0 do |job|
	count = getTasksLeftForActiveSprint(jira_board_id, jira_username, jira_password, jira_url)
 
	send_event('jira_tasks_left', current: count)
end