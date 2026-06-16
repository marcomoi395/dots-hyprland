# function fish_prompt -d "Write out the prompt"
#     # This shows up as USER@HOST /home/user/ >, with the directory colored
#     # $USER and $hostname are set by fish, so you can just use them
#     # instead of using `whoami` and `hostname`
#     printf '%s@%s %s%s%s > ' $USER $hostname \
#         (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
# end
#
if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # # Use starship
    starship init fish | source
    # if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    #     cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    # end

    # Aliases
    alias pamcan pacman
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'
    alias oc opencode
    alias n touch

    # 9router
    # alias 9router 'nvm use v22.22.2 && command 9router'

    # alias code nvim
    alias ws 'cd /run/media/ym/DATA/Workspace/'
    alias per 'cd /run/media/ym/DATA/Personal/'
    alias lo 'cd /run/media/ym/DATA/Workspace/vtd-micro-v3/vtd-service-loyalty-v3/'
    alias user 'cd /run/media/ym/DATA/Workspace/vtd-micro-v3/vtd-service-user-v3/'
    alias gift 'cd /run/media/ym/DATA/Workspace/vtd-micro-v3/vtd-service-gift-v3/'
    alias mi 'cd /run/media/ym/DATA/Workspace/vtd-micro-v3/'
    alias worker 'cd /run/media/ym/DATA/Workspace/vtd-micro-v3/vtd-service-worker-v3'
    alias import 'cd /run/media/ym/DATA/Workspace/vtd-micro-v3/vtd-service-import-v3'
    alias hera 'cd /run/media/ym/DATA/Personal/hera-flow/'

    # omp
    alias oh 'command omp --hook ~/.omp/agent/hooks/load_rules.ts'
    alias oh-review 'command omp --hook ~/.omp/agent/hooks/session-start-review.ts'

    alias conf 'cd ~/.config'
    alias v 'nvim .'
    alias c clear

    #npm
    alias ni 'pnpm install'
    alias ns 'pnpm start'
    alias nd 'pnpm run start:dev'
    alias yd 'yarn run dev'
    alias ys 'yarn start'

    #mvn
    # alias mvnrun 'mvn clean package -DskipTests -q && java -jar target/main-0.0.1-SNAPSHOT.jar --spring.profiles.active=thanh'

    alias n18 'nvm use 18'
    alias dc 'docker compose'
    alias gst 'git status'
    alias desktop 'cd /run/media/ym/8016C89B16C89416/Users/youngmarco/Desktop/'
    alias pt="QT_QPA_PLATFORM=xcb /usr/lib/packettracer/packettracer.AppImage --no-sandbox"
    # alias gh copilot
    alias lg lazygit
end

# set -gx nvm_default_version 18
# set -gx CHROME_EXECUTABLE /usr/bin/google-chrome-stable
# set -U fish_user_paths $HOME/Android/Sdk/emulator $fish_user_paths
# set -U fish_user_paths $HOME/Android/Sdk/platform-tools $fish_user_paths
# set -U fish_user_paths /home/ym/Android/Sdk/cmdline-tools/latest/bin $fish_user_paths
# set -U ANDROID_HOME /home/ym/Android/Sdk
# set -U ANDROID_SDK_ROOT /home/ym/Android/Sdk

function pm
    # Khởi tạo các giá trị mặc định
    set -l collection_id ""
    set -l env_id 36342424-9d3a1b75-ac01-44d1-afec-f28e227a3325 # ID mặc định
    set -l item_id "" # Thêm biến lưu ID cho flag -i
    set -l report_dir "./pm-report"
    set -l timestamp (date +%Y%m%d_%H%M%S)
    set -l report_name "report_$timestamp.html"
    set -l report_path "$report_dir/$report_name"

    # Parse arguments (Xử lý đầu vào)
    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case -e
                set -l next_idx (math $i + 1)
                if test $next_idx -le (count $argv)
                    set env_id $argv[$next_idx]
                    set i $next_idx
                else
                    echo "❌ Thiếu ID Environment sau option -e rồi ní!"
                    return 1
                end
            case -i
                set -l next_idx (math $i + 1)
                if test $next_idx -le (count $argv)
                    set item_id $argv[$next_idx]
                    set i $next_idx
                else
                    echo "❌ Thiếu ID Folder/Item sau option -i rồi ní!"
                    return 1
                end
            case '*'
                # Nếu không phải -e hay -i thì đích thị là Collection ID
                set collection_id $argv[$i]
        end
        set i (math $i + 1)
    end

    # Kiểm tra xem có truyền Collection ID chưa
    if test -z "$collection_id"
        echo "Ní ơi, thiếu ID Collection rồi!"
        return 1
    end

    # Tạo folder nếu chưa có
    mkdir -p $report_dir

    # Chuẩn bị lệnh chạy Postman CLI (Dùng mảng để handle flag -i linh hoạt)
    set -l postman_cmd collection run $collection_id -e $env_id --reporters html --reporter-html-export $report_path

    # Nếu có truyền -i thì nhét thêm vào câu lệnh
    if test -n "$item_id"
        set postman_cmd $postman_cmd -i $item_id
    end

    # Chạy Postman CLI
    postman $postman_cmd

    sleep 1

    if test -f $report_path
        nohup google-chrome-stable $report_path >/dev/null 2>&1 &
        disown
    else
        echo "❌ Đù, không thấy file $report_path đâu hết ní ơi!"
    end
end
