-- Test web-devicons functionality
print("Testing web-devicons...")

-- Test if nvim-web-devicons is available
local ok, web_devicons = pcall(require, 'nvim-web-devicons')

if ok then
  print("✅ nvim-web-devicons loaded successfully")
  
  -- Test getting an icon
  local icon, color = web_devicons.get_icon('test.py', 'py', { default = true })
  print("Python file icon:", icon)
  print("Python file color:", color)
  
  -- Test another file type
  local txt_icon, txt_color = web_devicons.get_icon('readme.txt', 'txt', { default = true })
  print("Text file icon:", txt_icon)
  print("Text file color:", txt_color)
  
else
  print("❌ nvim-web-devicons not available")
  print("Error:", web_devicons)
end
