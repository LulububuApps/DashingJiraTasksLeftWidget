## Description

Simple [Dashing](http://shopify.github.com/dashing) job to display the tasks left in the active [JIRA](https://de.atlassian.com/software/jira) sprint. Uses the jira agile api.

# Example

Check this screenshot:

![Screenshot](https://cloud.githubusercontent.com/assets/5159398/19269137/1732e3b0-8fb9-11e6-95d5-bf5c940ddcec.png)

## Usage

To use this widget put the `jira_tasks_left.rb` file in your `/jobs` folder.

To include the widget in a dashboard, add the following snippet to the dashboard layout file:
    
    <li data-row="1" data-col="2" data-sizex="1" data-sizey="1">
        <div data-id="jira_tasks_left" data-view="Number" data-title="Tasks left in current sprint"></div>
    </li>

## Settings

You'll need to add the JIRA username and password of a account that is able to access the sprint board. The tasks are fetched every 5 minutes, but you can change that by editing the job schedule.

## Advanced

Use [DashingLongNumberWidget](https://github.com/SocialbitGmbH/DashingLongNumberWidget) if you dont want `1000` story point displayed as `1K`.

Example:

    <li data-row="1" data-col="2" data-sizex="1" data-sizey="1">
        <div data-id="jira_tasks_left" data-view="Longnumber" data-title="Tasks left in current sprint"></div>
    </li>

## License  
    Copyright 2016 Socialbit GmbH

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.   