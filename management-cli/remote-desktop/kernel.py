import config
import ui
import requester

if __name__ == "__main__":
    config.requester = requester.Request()
    ui.first()
    ui.second()