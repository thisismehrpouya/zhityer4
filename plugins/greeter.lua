--[[
Sends a custom message when a user enters or leave a chat.
!welcome group
The custom message will send to the group. Recommended way.
!welcome pm
The custom message will send to private chat newly joins member.
Not recommended as a privacy concern and the possibility of user reporting the bot.
!welcome disable
Disable welcome service. Also, you can just disable greeter plugin.
--]]

do

local function is_banned(user_id, chat_id)
  local hash =  'banned:'..chat_id..':'..user_id
  local banned = redis:get(hash)
  return banned or false
end

local function is_super_banned(user_id)
    local hash = 'superbanned:'..user_id
    local superbanned = redis:get(hash)
    return superbanned or false
end

local function run(msg, matches)

  local data = load_data(_config.moderation.data)
  local welcome_stat = data[tostring(msg.to.id)]['settings']['welcome']

  if matches[1] == 'welcome' and is_mod(msg) then
    if matches[2] == 'group' then
      if welcome_stat ~= 'group' then
        data[tostring(msg.to.id)]['settings']['welcome'] = 'group'
        save_data(_config.moderation.data, data)
      end
      return 'Welcome service already enabled.\nWelcome message will shown in group.'
    end
    if matches[2] == 'pm' then
      if welcome_stat ~= 'private' then
        data[tostring(msg.to.id)]['settings']['welcome'] = 'private'
        save_data(_config.moderation.data, data)
      end
      return 'Welcome service already enabled.\nWelcome message will send as private message to new member.'
    end
    if matches[2] == 'disable' then
      if welcome_stat == 'no' then
        return 'Welcome service is not enabled.'
      else
        data[tostring(msg.to.id)]['settings']['welcome'] = 'no'
        save_data(_config.moderation.data, data)
        return 'Welcome service has been disabled.'
      end
    end
  end

  if welcome_stat ~= 'no' and msg.action and msg.action.type then
    local action = msg.action.type
    if action == 'chat_add_user' or action == 'chat_add_user_link' or action == "chat_del_user" then
      if msg.action.link_issuer then
        user_id = msg.from.id
        new_member = (msg.from.first_name or '')..' '..(msg.from.last_name or '')
        if msg.from.username then
          username = '@'..msg.from.username..' AKA '
        else
          username = ''
        end
        user_flags = msg.flags
      else
	      user_id = msg.action.user.id
        new_member = (msg.action.user.first_name or '')..' '..(msg.action.user.last_name or '')
        if msg.action.user.username then
          username = '@'..msg.action.user.username..' AKA '
        else
          username = ''
        end
        user_flags = msg.action.user.flags
      end
      -- do not greet (super)banned users or API bots.
      local superbanned = is_super_banned(user_id)
      local banned = is_banned(user_id, msg.to.id)
      if superbanned or banned then
        print 'Ignored. User is banned!'
        return nil
      end
      if user_flags == 4352 then
        print 'Ignored. It is an API bot.'
        return nil
      end
    end

    if matches[1] == 'chat_add_user' or matches[1] == 'chat_add_user_link' then
      if data[tostring(msg.to.id)] then
        local about = ''
        local rules = ''
        if data[tostring(msg.to.id)]['description'] then
          about = data[tostring(msg.to.id)]['description']
          about = '\nDescription :\n'..about..'\n'
        end
        if data[tostring(msg.to.id)]['rules'] then
          rules = data[tostring(msg.to.id)]['rules']
          rules = '\nRules :\n'..rules..'\n'
        end
        local welcomes = 'عزیز '..new_member..' خوش آمدی\n'
                         ..'.'..msg.to.title..' به گروه\n'
        if welcome_stat == 'group' then
          receiver = get_receiver(msg)
        elseif welcome_stat == 'private' then
          receiver = 'user#id'..msg.from.id
        end
        send_large_msg(receiver, welcomes..about..rules..'\n', ok_cb, false)
      end
    elseif matches[1] == 'chat_del_user' then
      return 'Bye '..new_member..'!'
    end
  end
end

return {
  description = 'Sends a custom message when a user enters or leave a chat.',
  usage = {
    moderator = {
      '!welcome group : ارسال پیام خوش امد گویی در گروه',
      '!welcome disable : غیرفعال کردن پیام خوش آمد گویی'
    },
  },
  patterns = {
    "^!!tgservice (.+)$",
    "^!(welcome) (.*)$"
  },
  run = run,
}

end
