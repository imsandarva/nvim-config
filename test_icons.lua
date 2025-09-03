-- Test file to check if basic icon functionality works
local function test_icons()
  -- Test if we can display basic icons
  print("Testing basic icon display:")
  print("🐍 Python icon")
  print("🖼️ Image icon") 
  print("📄 Document icon")
  print("📁 Folder icon")
  
  -- Test if nvim-web-devicons is available
  local ok, web_devicons = pcall(require, 'nvim-web-devicons')
  if ok then
    print("✅ nvim-web-devicons loaded successfully")
    print("Available file types:", #web_devicons.get_icons())
  else
    print("❌ nvim-web-devicons not available")
  end
end

test_icons()
