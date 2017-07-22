###############################################
@finish_feedback = (feedback, user) ->
	if not feedback.rating
		throw new Meteor.Error "Feedback: " + feedback._id + " Does not have a rating."

	if feedback.published
		throw new Meteor.Error "Feedback: " + feedback._id + " is already published."

	modify_field_unprotected Feedback, feedback._id, "published", true

	feedback = Feedback.findOne feedback._id
	send_feedback_message feedback

	msg = "Feedback (" + feedback._id + ") feedback finished by: " + get_user_mail user
	log_event msg, event_logic, event_info

	return feedback._id


###############################################
@repair_feedback = (solution, review, user) ->
	filter =
		solution_id: solution._id
		review_id: review._id
	feedback = Feedback.findOne filter

	if feedback
		return feedback._id

	return gen_feedback solution, review, user


###############################################
@gen_feedback = (solution, review, user) ->
	if solution._id != review.solution_id
		msg = "solution._id: " + solution._id
		msg += " differs from review.solution_id :" + review.solution_id
		log_event msg, event_create, event_crit
		throw new Meteor.Error msg

	feedback =
		owner_id: solution.owner_id
		parent_id: review._id
		review_id: review._id
		solution_id: solution._id
		challenge_id: solution.challenge_id
		requester_id: review.owner_id
		visible_to: "owner"
		template_id: "feedback"
		requested: new Date()
		assigned: false
		published: false

	feedback_id = store_document_unprotected Feedback, feedback
	return feedback_id


###############################################
@reopen_feedback = (feedback, user) ->
	throw new Meteor.Error("not implemented")



