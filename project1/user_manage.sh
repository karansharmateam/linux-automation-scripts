#!/bin/bash

# --- Security Check: Ensure script runs with root/sudo permissions ---
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root or with sudo."
   exit 1
fi

# --- Function: User Management ---
manage_users() {
    echo "1. Add User"
    echo "2. Delete User"
    echo "3. Modify User (Change Shell)"
    read -p "Choose an option: " user_opt

    case $user_opt in
        1)
            read -p "Enter username to add: " username
            useradd -m "$username" && echo "User $username created successfully."
            ;;
        2)
            read -p "Enter username to delete: " username
            userdel -r "$username" && echo "User $username and home directory removed."
            ;;
        3)
            read -p "Enter username: " username
            read -p "Enter new shell path (e.g., /bin/bash): " nshell
            usermod -s "$nshell" "$username" && echo "Shell updated for $username."
            ;;
        *) echo "Invalid option." ;;
    esac
}

# --- Function: Group Management ---
manage_groups() {
    read -p "Enter 1 to Create Group, 2 to Add User to Group: " grp_opt
    if [ "$grp_opt" == "1" ]; then
        read -p "Enter group name: " groupname
        groupadd "$groupname" && echo "Group $groupname created."
    elif [ "$grp_opt" == "2" ]; then
        read -p "Enter username: " username
        read -p "Enter group name: " groupname
        usermod -aG "$groupname" "$username" && echo "Added $username to $groupname."
    else
        echo "Invalid choice."
    fi
}

# --- Function: Backup and Compression ---
backup_dir() {
    read -p "Enter the full path of the directory to backup: " target_dir
    if [ -d "$target_dir" ]; then
        backup_name="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
        tar -czf "$backup_name" "$target_dir"
        echo "Backup completed: $backup_name"
    else
        echo "Error: Directory does not exist."
    fi
}

# --- Main Menu ---
clear
echo "=========================================="
echo "   LINUX ADMIN & BACKUP TOOL"
echo "=========================================="
echo "1. User Management"
echo "2. Group Management"
echo "3. Backup a Directory"
echo "4. Exit"
echo "------------------------------------------"
read -p "Select an option [1-4]: " main_opt

case $main_opt in
    1) manage_users ;;
    2) manage_groups ;;
    3) backup_dir ;;
    4) exit 0 ;;
    *) echo "Invalid selection. Exiting." ;;
esac
