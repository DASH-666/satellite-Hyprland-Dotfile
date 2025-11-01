#include <array>
#include <iostream>
#include <memory>
#include <string>

std::string execCommand(const char *cmd) {
  std::array<char, 256> buffer;
  std::string result;
  std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);

  if (!pipe)
    return "unknown";

  while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr)
    result += buffer.data();

  return result;
}

int main() {
  std::string layout = execCommand("hyprctl devices -j | jq -r '.keyboards[] | "
                                   "select(.main == true) | .active_keymap'");

  // Remove trailing newline
  layout.erase(layout.find_last_not_of(" \n\r\t") + 1);

  if (layout == "English (US)")
    std::cout << "EN";
  else if (layout == "Persian")
    std::cout << "FA";
  else
    std::cout << layout;

  return 0;
}
