do

local function run(msg)
   if is_sudo(msg) or is_admin(msg) then
    return "You're not admin"
end

return {
  description = "good", 
  patterns = {
    "^!fuckoff",
  },
  run = run
}

end
