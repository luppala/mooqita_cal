###############################################
Meteor.methods
	migrate_database: () ->
		collections = [Challenges, Solutions, Reviews, Feedback, Messages, Profiles]

		for collection in collections
			collection.find().forEach (e) ->
				if e.owner_id
					gen_admission(collection, e, e.owner_id, OWNER)
					console.log "Add admission owner: ", get_collection_name collection, e._id

		Profiles.find().forEach (e) ->
			if e.owner_id
				modify_field_unprotected(Profiles, e._id, "user_id", e.owner_id)
				console.log get_collection_name collection, e._id

	clean_admissions: () ->
		crs = Admissions.find()
		dead = []
		crs.forEach (adm) ->
			u_crs = Meteor.users.find(adm.consumer_id)
			if u_crs.count() > 0
				return
			dead.push(adm._id)

		filter =
			_id:
				$in: dead

		count = Admissions.remove(filter)
		return count

