# -*- encoding: utf-8 -*-
module KoalaHelper # :nodoc:

  def facebook_permissions
    Facebook::PERMISSIONS
  end

  def facebook_app_id # :nodoc:
    Facebook::APP_ID
  end

  def facebook_session # :nodoc:
    @facebook_session ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(request.cookies) || {}
  end

  def facebook_token # :nodoc:
    @facebook_access_token ||= facebook_session['access_token']
  end

  def facebook_uid # :nodoc:
    @facebook_uid ||= facebook_session['uid']
  end

  def facebook_session_key # :nodoc:
    @facebook_session_key ||= facebook_session['session_key']
  end
end