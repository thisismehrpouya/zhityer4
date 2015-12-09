do

function run(msg, matches)
  return 'برای سفارش گروه ضداسپم به ایدی @policetg_admin مراجعه کنید'
end

return {
  description = "Shows bot version", 
  usage = "!version: درباره ربات",
  patterns = {
    "^!version$"
  }, 
  run = run 
}

end
