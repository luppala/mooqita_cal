################################################
Template.mooqita_layout.onCreated ->
	self = this
	self.is_ready = new ReactiveVar(false)

	self.autorun ->
		filter =
			owner_id: Meteor.userId()

		Meteor.subscribe "responses", "Profiles", filter, "body_template.onCreated",
			(err, exp) ->
				console.log err
				console.log exp
				self.is_ready.set true

Template.mooqita_layout.helpers
	profile_ready: ->
		return Template.instance().is_ready.get()