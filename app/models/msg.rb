#encoding: utf-8
#require 'soap/wsdlDriver'

class Msg < ActiveRecord::Base

  def self.user_registed(user)
    #return if !user

    #msg = Msg.new
    #msg.sender = '新用户注册'
    #msg.sendee = user.display_name
    #msg.sendee_id = user.id
    #msg.address = user.mobile
    #msg.msg_type = 'SMS'
    #msg.msg_title = '酷购coolpur.com'
    #msg.msg_body = '酷购coolpur.com:欢迎您注册成为会员！您的登录密码为:' + user.password + '。酷购以专业渠道管理，为您提供手机低价直供服务！'
    #msg.status = 0

    #msg.save!
  end
end
