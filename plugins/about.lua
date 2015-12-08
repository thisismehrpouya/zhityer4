do

function run(msg, matches)
  return 'PoliceTG '
  '
  برای سفارش گروه ضداسپم به ایدی زیر مراجعه کنید.
  @policetg_admin'
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
