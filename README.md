# theMet-slack
Retrieves a random piece from the collection of The Metropolitan Museum of Art.

![example image 1](http://i.imgur.com/QvUiQOW.png)
Powered by [scrAPI](http://scrapi.org/) and [The Metropolitan Museum of Art](http://www.metmuseum.org/)

### What you will need
* A [Heroku](http://www.heroku.com) account
* An [outgoing webhook token](https://api.slack.com/outgoing-webhooks) for your Slack team

### Setup
* Clone this repo locally
* Create a new Heroku app and initialize the repo
* Push the repo to Heroku
* Navigate to the settings page of the Heroku app and add the following config variables:
  * ```OUTGOING_WEBHOOK_TOKEN``` The token for your outgoing webhook integration in Slack
  * ```BOT_USERNAME``` The name the bot will use when posting to Slack
  * ```BOT_ICON``` The emoji icon for the bot (I used the book emoji)
* Navigate to the integrations page for your Slack team. Create an outgoing webhook, choose a trigger word (ex: "random art"), use the URL for your heroku app, and copy the webhook token to your ```OUTGOING_WEBHOOK_TOKEN``` config variable.
