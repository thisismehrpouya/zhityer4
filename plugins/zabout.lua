do

function run(msg, matches)
  return 'برای سفارش گروه ضداسپم به ایدی @policetg_admin مراجعه کنید'
end

return {
  description = "Shows bot about", 
  usage = {
    "!about: درباره ربات",
   },
  patterns = {
    "^!about$"
  }, 
  run = run 
}

end
