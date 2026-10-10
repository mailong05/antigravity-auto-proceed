import ctypes
import time
import winsound

user32 = ctypes.windll.user32

VK_F8 = 0x77         # F8 key for Toggle
VK_1 = 0x31          # Key '1'
KEYEVENTF_KEYUP = 0x0002

def is_key_pressed(vk):
    return (user32.GetAsyncKeyState(vk) & 0x8000) != 0

def get_active_window_title():
    hwnd = user32.GetForegroundWindow()
    length = user32.GetWindowTextLengthW(hwnd)
    if length == 0:
        return ""
    buff = ctypes.create_unicode_buffer(length + 1)
    user32.GetWindowTextW(hwnd, buff, length + 1)
    return buff.value

def press_key_1():
    # Press key 1
    user32.keybd_event(VK_1, 0, 0, 0)
    time.sleep(0.05)
    # Release key 1
    user32.keybd_event(VK_1, 0, KEYEVENTF_KEYUP, 0)

def main():
    enabled = False
    print("=" * 55)
    print("       [Antigravity Auto-Accept Tool]")
    print(" - Press [F8] to TOGGLE auto-pressing key 1")
    print(" - Press [Ctrl + C] to QUIT")
    print("=" * 55)
    print("Current status: OFF")

    last_f8_state = False

    while True:
        f8_state = is_key_pressed(VK_F8)
        if f8_state and not last_f8_state:
            enabled = not enabled
            if enabled:
                print(">> [ON] Auto-pressing key 1 when Antigravity is active...")
                winsound.Beep(1200, 150)
            else:
                print(">> [OFF] Paused.")
                winsound.Beep(600, 150)
            time.sleep(0.3)
        last_f8_state = f8_state

        if enabled:
            title = get_active_window_title().lower()
            if "antigravity" in title:
                press_key_1()
                time.sleep(0.8)

        time.sleep(0.1)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nTool stopped.")
