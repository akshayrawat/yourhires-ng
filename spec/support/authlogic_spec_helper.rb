def login_as(recruiter)
  controller.session["recruiter_credentials"] = recruiter.persistence_token
  controller.session["recruiter_credentials_id"] = recruiter.id
end