#!/bin/sh

#use 'sh' for best compatible caps.
#Kiloview KiloLink Server auto install script.

usage() {
    echo "Usage:"
    echo "    $1 [image-package] [-h|--help]"
    echo
    echo "If the 'image-package' file name is specified, load the docker image of KiloLink Server from the specified file and complete the installation. Otherwise, the KiloLink Server public image provided by Kiloview will be downloaded from docker-hub to complete the installation."
    return 0
}

#Or user can also specify IMAGE by environment var, for example:
# IMAGE=/path/to/image /bin/bash <( curl -fsSL https://.... )
while [ $# -gt 0 ]; do
    if [ "$1" = "-h" -o "$1" = "--help" ]; then
        usage $0
        exit 0
    else
        IMAGE="$1"
        break
    fi
    shift
done

#User can specify VER=... while run this script the specify version.
#eg. VER=latest /bin/bash <( curl -fsSL https://.... )
if [ -z "$VER" ]; then
    VER="latest"
fi

#User can specify REPO=... while run this script to replace the default REPO.
#eg. REPO=kiloview/klnk-pro-test /bin/bash <( curl -fsSL https://.... )
if [ -z "$REPO" ]; then
    REPO="kiloview/klnk-pro"
fi

#Merge them together
REPO="$REPO:$VER"

CONTAINER_NAME="KLNKSVR-pro"

[ -n "$PAGER" ] || PAGER=more

if command -v "$PAGER" > /dev/null; then
	view_eula="$PAGER"
else
	view_eula=cat
fi

$view_eula << KLS_EULA_END

Kiloview® KiloLink Server (KLS) License Agreement

Please read this document carefully before proceeding. You (the undersigned Licensee) hereby agree to the terms of this Kiloview® KiloLink Server (KLS) License Agreement (the "License") in order to use the software. Kiloview Electronics Co., Ltd. agrees to grant you certain rights as set forth herein under these terms.

1. Definitions
a. "Kiloview" refers to the company name Kiloview Electronics Co., Ltd. Kiloview® is a registered trademark of Kiloview Electronics Co., Ltd.
b. "KLS" means the entirety of the Kiloview® KiloLink Server, including those portions pertaining to specific software provided to you under this License, including any source code, compiled executables or libraries, Docker images or containers, and all documentation provided to you.
d. "KLS Documentation" refers to the documentation provided with the KLS software, including the portion pertaining to the Specific KLS.
e. "Specific KLS" refers to the specific KLS for which you intend to use the Kiloview® KLS under the constraints of this License for other special purposes (for example, integration with your systems and accomplishing certain objectives through API calls). These are examples only, and Kiloview may add or subtract to this list at its discretion, and you agree to use them only in accordance with this Agreement, including the documentation related to it.

2. License
a. Pursuant to the terms, conditions, and requirements of this License and the KLS Documentation, you are hereby granted a nonexclusive royalty-free license to use the KLS for managing products or devices produced and sold by Kiloview that are suitable for management and control by KLS. A separate license agreement with Kiloview is required in order to commercially exploit or otherwise distribute any products that use or embed the KLS software, or use part or all of the KLS and/or Specific KLS.
b. This is a License only, and no employment, joint venture, partnership, or other business enterprise is created by this License.
c. Unless otherwise stated in the KLS, no software, installation programs, scripts, Docker images, or any files within the Specific KLS may be distributed.
d. You agree to comply with the steps outlined in the KLS documentation, including the KLS installation and usage manual. Kiloview may impose different obligations and restrictions with respect to different Specific KLS.
e. Kiloview provides the KLS software only under the specific conditions herein for the purpose of managing and controlling Kiloview-related products. If any terms of this License are not enforceable in your legal jurisdiction in any way, or any clause is voided or modified in any way, then you may not enter into this agreement, any license and permission granted herein is revoked and withdrawn as of the date you first downloaded and/or used the KLS, and you are then unauthorized to copy, create derivative works, or otherwise use the KLS in any way.

3. Restrictions and Confidentiality
a. "Confidential Information" includes the KLS and all specifications, scripts, source code, examples, tools, and documentation provided within the KLS, and any support thereof, and any other proprietary information provided by Kiloview and identified as Confidential in the course of assisting you with your KLS implementation. Confidential Information does not include information that: 1) is or becomes generally available to the public other than as a result of a disclosure by you, or 2) becomes available to you on a non-confidential basis from a source that was not prohibited from disclosing such information. Except as authorized herein, or in the KLS Documentation, or as otherwise approved in writing by Kiloview: 1) The disclosure to you of the KLS and all other Confidential Information shall not be disclosed to any third party; 2) You agree not to commercialize the Confidential Information for yours or others' benefit in any way; 3) You will not make or distribute copies of the KLS, or other Confidential Information, or electronically transfer the KLS to any individual within your business or company who does not need to know or view the KLS, and under no circumstances shall you disclose it, or any part of it, to any company, or any other individual not employed directly by the business or company you represent, without express written permission of Kiloview.
b. You will not modify, sell, rent, transfer, resell for profit, distribute, or create derivative works based upon the KLS or any part thereof; however, you may install the KLS software on your computer, server, or cloud for the purpose of utilizing the KLS software features, or for other purposes expressly set forth by you in advance in writing and agreed to in writing by Kiloview.
c. You will comply with applicable export control and trade sanctions laws, rules, regulations, and licenses and will not export or re-export, directly or indirectly, the KLS into any country, to any organization or individual prohibited by the Export Administration Act and the regulations thereunder of the People's Republic of China.
d. You agree not to use the KLS for any unlawful purpose or in any way to cause injury, harm or damage to Kiloview, its products, trademarks, reputation, and/or goodwill, or use information provided pursuant to the KLS, to interfere with Kiloview in the commercialization of Kiloview products.
e. Kiloview owns or has licensed copyright rights to the KLS. In any use scenario of the KLS, you agree to include all applicable copyright notices, along with yours, indicating Kiloview's copyright rights as applicable and as requested by Kiloview.
f. You agree not to reverse engineer, disassemble or recompile the KLS or any part thereof, or attempt to do so.
g. You agree not to use the KLS for purposes other than those for which it was originally designed, particularly, you agree not to use the KLS for any purpose but for the precise purposes as expressly identified to Kiloview in writing that form the basis of the KLS and this license, and you agree you will not attempt to violate any of the foregoing, or encourage third parties to do so.

4. Software Defect Reporting
If you find software defects in the KLS, you agree to make reasonable efforts to report them to Kiloview in accordance with the KLS documentation or in such other manner as Kiloview directs in writing. Kiloview will evaluate and, at its sole discretion, may address them in a future revision of the KLS. Kiloview does not warrant the KLS to be free of defects.

5. Updates
You understand and agree that Kiloview may amend, modify, change, and/or cease distribution or production of the KLS at any time. You understand that you are not entitled to receive any upgrades, updates, or future versions of the KLS under this License. Kiloview does not warrant or represent that its future updates and revisions will be compatible with existing versions.

6. Ownership
Nothing herein is intended to convey to you any patent, trademark, copyright, trade secret or other Intellectual Property owned by Kiloview or its Licensors in the KLS or in any Kiloview software, hardware, products, trade names, or trademarks. Kiloview and its suppliers or licensors shall retain all right, title, and interest in the foregoing Intellectual Property and to the KLS. All rights not expressly granted herein are reserved by Kiloview.

7. Indemnity and Limitations
You agree to indemnify and hold Kiloview harmless from any third party claim, loss, or damage (including attorney's fees) related to your use, sale or distribution of the KLS. The KLS is provided to you free of charge, and on an "AS IS" basis and "WITH ALL FAULTS", without any technical support or warranty of any kind from Kiloview. You assume all risks that the KLS is suitable or accurate for your needs and your use of the KLS is at your own discretion and risk. Kiloview and its licensors disclaim all express and implied warranties for the KLS including, without limitation, any warranty of merchantability or fitness for a particular purpose. Also, there is no warranty of non-infringement, title or quiet enjoyment. Some states do not allow the exclusion of implied warranties, so the above exclusion may not apply to you. You may also have other legal rights that vary from state to state.

8. Limitation of Damages
Neither Kiloview nor its suppliers or licensors shall be liable for any indirect, special, incidental or consequential damages or loss (including damages for loss of business, loss of profits, or the like), arising out of this License whether based on breach of contract, tort (including negligence), strict liability, product liability or otherwise, even if Kiloview or its representatives have been advised of the possibility of such damages. Some states do not allow the limitation or exclusion of liability for incidental or consequential damages, so this limitation or exclusion may not apply to you. The limited warranty, exclusive remedies and limited liability set forth above are fundamental elements of the basis of the bargain between Kiloview and you. You agree that Kiloview would not be able to provide the Software on an economic basis without such limitations. In no event will Kiloview be liable for any amount greater than what you actually paid for the KLS.

9. Termination
Either party may terminate this License upon thirty (30) days written notice. Either party may also terminate if the other party materially defaults in the performance of any provision of this License, the non-defaulting party gives written notice to the other party of such default, and the defaulting party fails to cure such default within ten (10) days after receipt of such notice. Upon the termination of this License, the rights and licenses granted to you by Kiloview pursuant to this License will automatically cease. Nothing herein shall prevent either party from pursuing any injunctive relief at any time if necessary, or seeking any other remedies available in equity. Each party reserves the right to pursue all legal and equitable remedies available. Upon termination, all KLS materials shall be promptly returned to Kiloview, and any and all copies stored in electronic or other format shall be deleted and destroyed, and any rights to use Kiloview’s trademarks are revoked. If this License is terminated for any reason, the provisions of Sections 1, 3, 6, 7, 8, 9, 10, and 11 shall survive such termination.

10. General
Notices given hereunder may be sent to either party at the address below by either overnight mail or by email and are deemed effective when sent. This License shall be governed by the laws of the People's Republic of China, without regard to its choice of law rules, and you agree to exclusive jurisdiction therein. This License contains the complete agreement between you and Kiloview with respect to the subject matter (KLS) of this License, and supersedes all prior or contemporaneous agreements or understandings, whether oral or written. It does not replace any licenses accompanying Kiloview products. You may not assign this KLS License.

May 2024    Kiloview® Software License Agreement

KLS_EULA_END

while true; do
    read -p "You must Type [y/Y] to agree, Type [n/N] to disagree: " CONFIRM
    if [ ! -z "$CONFIRM" ]; then
        if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
	        exit 1
        fi
        break
    fi
done

check_docker() {
    # Check docker
    if ! command -v docker > /dev/null 2>&1; then
        echo "[ERROR!] \`Docker\` is not found in your system!" >&2
        echo >&2
        echo "To install KiloLink Server, you need to have a \`Docker\` container system installed on your system." >&2
        echo "Docker is a widely used containerization technology that can help simplify the installation and deployment of complex software systems, and is easy to use. Due to Docker being a system service, for security and compatibility reasons, please install it yourself first." >&2
        echo >&2
        echo "If you are new to Docker, try this command to install it:" >&2
        echo >&2
        echo "curl -fsSL https://get.docker.com | /bin/bash" >&2
        echo >&2
        exit 1
    fi

    # Check docker permissions
    if ! docker ps > /dev/null 2>&1; then
        echo "[ERROR!] Permission denied while running \`docker\`. Please run this script with a user that has Docker execution permissions." >&2
        exit 1
    fi
}

#NO-USED now.
#check_ip_legitimacy() {
#    ip=$1
#    while true
#    do
#        regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
#        if [[ $ip =~ $regex ]]; then
#            IFS='.' read -r -a parts <<< "$ip"
#            valid=true
#            for part in "${parts[@]}"; do
#                if ! [[ "$part" =~ ^[0-9]+$ ]] || [[ "$part" -gt 255 ]]; then
#                    valid=false
#                    break
#                fi
#            done
#            if [ "$valid" = true ]; then
#                break
#            fi
#        fi
#        read -p "IP '${ip}' format is not legal, please re-enter: " ip
#    done
#    echo $ip
#}

check_history_containers() {
    containers=

    checker=`docker ps -a | grep "$CONTAINER_NAME" | awk '{print $NF}'`
    if [ ! -z "$checker" ]; then
        containers="$containers $checker"
    fi

    checker=`docker ps -a | grep "kilolinkserver" | awk '{print $NF}'`
    if [ ! -z "$checker" ]; then
        containers="$containers $checker"
    fi

    checker=`docker ps -a | grep "klnkserver" | awk '{print $NF}'`
    if [ ! -z "$checker" ]; then
        containers="$containers $checker"
    fi

    checker=`docker ps -a | grep "kilolinkserverfree" | awk '{print $NF}'`
    if [ ! -z "$checker" ]; then
        containers="$containers $checker"
    fi

    checker=`docker ps -a | grep "kilolink-streamer-server" | awk '{print $NF}'`
    if [ ! -z "$checker" ]; then
        containers="$containers $checker"
    fi
    echo $containers
}

get_port() {
    #Note:
    # arg-1: Prompt 
    # arg-2: 0=default(1 port), 1=odd/even
    # arg-3: low port
    # arg-4: high port
    NUM=
    EVEN_ODD=
    COMPARE_LOW=1
    COMPARE_HIGH=65535

    if [ -z "$2" -o "$2" = "0" ]; then
        :
    else
        EVEN_ODD=y
    fi

    if [ ! -z "$3" ]; then COMPARE_LOW="$3"; fi
    if [ ! -z "$4" ]; then COMPARE_HIGH="$4"; fi

    while true; do
        read -p "$1" NUM
        if [ ! -z "$NUM" ]; then
            echo "$NUM" | grep '^[[:digit:]]*$' > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                if [ $NUM -ge $COMPARE_LOW -a $NUM -le $COMPARE_HIGH ]; then
                    if [ -z "$EVEN_ODD" ]; then
                        #TODO: Check in use.
                        echo $NUM
                        break
                    else
                        temp_var=`expr $NUM / 2 '*' 2`
                        if [ "$temp_var" != "$NUM" ]; then
                            echo "[ERROR!] You must input an even number." >&2
                        else
                            #TODO: Check in use.
                            echo $NUM
                            break
                        fi
                    fi
                else
                    echo "[ERROR!] Invalid port range, must be in range [$COMPARE_LOW~$COMPARE_HIGH]." >&2
                fi
            else
                echo "[ERROR!] Invalid port digits." >&2
            fi
        else
            break
        fi
    done
    return 0
}

install() {
    #Step 1. Load or download docker image.
    echo "-------------------------------------------------"
    echo "#1. Load/download docker images"
    echo "-------------------------------------------------"
    echo
    if [ ! -z "$IMAGE" ]; then
        if [ ! -f "${IMAGE}" ]; then
            echo "[ERROR!] The docker image '${IMAGE}' is not exists!" >&2
            exit 1
        fi
        echo "Loading the docker image for file '${IMAGE}' ..."
        docker load -i "${IMAGE}"
        if [ $? -ne 0 ]; then 
            echo "[ERROR!] Failed loading KiloLink Server image!" >&2 
            exit 1
        fi
    else
        echo "Pulling/updating the software images from '${REPO}' ..."
        docker pull "${REPO}"
        if [ $? -ne 0 ]; then 
            echo "[ERROR!] Failed get KiloLink Server image!" >&2 
            exit 1
        fi
    fi

    echo
    echo "Congratulations! The image is ready. Now please follow the instructions to complete the installation step by step."
    echo

    INSTALL_PATH="$HOME/kilolink-server"

    #Step-2. Confirm the install directory.
    echo "-------------------------------------------------"
    echo "#2. Where do you want to install KiloLink Server"
    echo "-------------------------------------------------"
    echo "You can input your install path below, or just press ENTER to install into default location [$INSTALL_PATH]" 
    echo

    while true; do
        read -p "[$INSTALL_PATH] >" INPUT
        if [ ! -z "$INPUT" ]; then
            if [ -d "$INPUT" ]; then
                echo "[WARNING!] '$INPUT' is an exists directory! If you install KiloLink Server there and an exists KiloLink Server is there, it will try to keep the old system configurations, But we cannot guarantee that this is completely correct. So before that, it is recommended that you backup the data there before performing the overwrite installation."
                read -p "Are you sure to install into there? [y/N]" CONFIRM
                if [ "$CONFIRM" = "y" -o "$CONFIRM" = "Y" ]; then
                    INSTALL_PATH="$INPUT"
                    break
                else
                    echo "So input your path again, or just press ENTER to install into default location, CTRL+C to exit."
                fi
            elif [ -e "$INPUT" ]; then
                echo "[ERROR!] '$INPUT' is exists and not a directory!"
                echo "Input your path again, or just press ENTER to install into default location, CTRL+C to exit."
            else
                INSTALL_PATH="$INPUT"
                break
            fi
        else
            break
        fi
    done

    mkdir -p "$INSTALL_PATH" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "ERROR! Can not create directory at '$INSTALL_PATH'!"
        exit 1
    fi

    #Step-3. Check old configurations
    echo 
    echo "-------------------------------------------------"
    echo "#3. Checking your old configurations"
    echo "-------------------------------------------------"
    web_port=80
    klnk_port=50000
    docker_container=
    old_version=

    if [ -f "$INSTALL_PATH/serverinfo.conf" ]; then
        checker=`cat "$INSTALL_PATH/serverinfo.conf" | grep web_port | cut -d ':' -f 2`
        if [ ! -z "$checker" ]; then
            old_version=y
            web_port="$checker"
        fi

        #old version cases.
        checker=`cat "$INSTALL_PATH/serverinfo.conf" |grep server_port | cut -d ':' -f 2`
        if [ ! -z "$checker" ]; then
            old_version=y
            klnk_port="$checker"
        fi

        #new version cases
        checker=`cat "$INSTALL_PATH/serverinfo.conf" |grep klnk_port | cut -d ':' -f 2`
        if [ ! -z "$checker" ]; then
            old_version=y_new
            klnk_port="$checker"
        fi

        checker=`cat "$INSTALL_PATH/container.conf" 2>/dev/null`
        if [ ! -z "$checker" ]; then
            old_version=y_new
            docker_container="$checker"
        fi
    fi

    #Step-4. Check old container
    echo 
    echo "Checking the old software versions (docker containers) ..."

    if [ ! -z "$docker_container" ]; then
        old_containers=`docker ps -a 2>/dev/null | grep "$docker_container" | awk '{print $1}'`
        old_container_names=`docker ps -a 2>/dev/null | grep "$docker_container" | awk '{print $NF}'`
        if [ ! -z "$old_containers" ]; then
            echo "[WARNING] Found these old version contain(s): "
            echo " ($old_container_names)"
            echo "It requires to remove all of them, but this may affect your existing business, so before REMOVING, please carefully confirm to avoid causing losses!"
            echo
            read -p "Are you sure to REMOVE them? [y/N]" CONFIRM
            if [ "$CONFIRM" = "y" -o "$CONFIRM" = "Y" ]; then
                :
            else
                exit 1
            fi

            echo "Removing old containers: $old_container_names ..."
            docker rm -f $old_containers
        fi
    else
        old_container_names=`check_history_containers`
        location_type="brand new location"
        if [ ! -z "$old_version" ]; then
            location_type="exists location but the software is the old version"
        fi

        echo
        echo "[WARNING] You are installing the KiloLink Server to an $location_type, so I can't exactly know what container the old version is."
        echo "I have discovered some containers that are suspected to be older versions, as follows:"
        echo " ($old_container_names)"
        echo "So this requires you to confirm whether certain containers need to be DELETED. However, please note that deleting old containers may affect your existing business, so please choose carefully; If the old container is not deleted, it may cause the new software to not work properly. If you are still unsure, please press CTRL+C to exit and seek necessary assistance."
        echo
        while true; do
            read -p "(Enter DELETING container names separated by spaces) >" INPUT
            if [ ! -z "$INPUT" ]; then
                read -p "Again, are you sure to delete these containers? [y/N]" CONFIRM
                echo
                if [ "$CONFIRM" = "y" -o "$CONFIRM" = "Y" ]; then
                    echo "Deleteing containers: $INPUT ..."
                    docker rm -f $INPUT
                    break
                fi
            else
                break
            fi
        done
    fi

    #stream_server_ip=""
    #[ -f "/data/streamer-server/server_controller.conf" ] && stream_server_ip=`cat /data/streamer-server/server_controller.conf |grep stream_ip |cut -d ":" -f 2 |cut -d "," -f 1 |cut -d " " -f 2`
    #stream_klnk_port=65500
    #[ -f "/data/streamer-server/server_controller.conf" ] && stream_klnk_port=`cat /data/streamer-server/server_controller.conf |grep bond_udp_port |cut -d ":" -f 2 |cut -d "," -f 1 |cut -d " " -f 2`

    # Step-5. configure install.
    echo
    echo "-------------------------------------------------"
    echo "#4. Configure your installation"
    echo "-------------------------------------------------"
    echo
    echo "Web port is for your Web/HTTP accessing KiloLink Server management console."
    echo
    INPUT=`get_port "Web port:[$web_port] >"`
    if [ ! -z "$INPUT" ]; then
        web_port="$INPUT"
    fi

    echo
    echo "Link port is for devices connection for aggregation/management purpose."
    echo "(NOTE: the link port must be an EVEN NUMBER, and when creating a KiloLink service, it will occupy both the [link_port] and [link_port+1] ports.)"
    echo
    klnk_port=`expr $klnk_port / 2 '*' 2`
    INPUT=`get_port "Link port:[$klnk_port] >" 1`
    if [ ! -z "$INPUT" ]; then
        klnk_port="$INPUT"
    fi
    stream_klnk_port=`expr $klnk_port + 1`

    stream_server_ip=
    echo
    echo "Public IP address provided by your system for external access"
    echo "(I need to know the public IP address that your system provides for external access, and based on my automatic detection, the IP on the NICs is not trusted. Because in a Cloud system, the public IP you are accessing externally is not configured on your local NICs, so you need to manually fill in this IP address.)"
    echo
    while true; do
        read -p ">" INPUT
        if [ ! -z "$INPUT" ]; then
            #TODO: Verify the IP address validation.
            stream_server_ip="$INPUT"
            break
        fi
    done

    no_avahi=
    echo
    echo "-------------------------------------------------"
    echo "#5. Finally checking ..."
    echo "-------------------------------------------------"
    echo
    if command -v avahi-daemon > /dev/null; then
        :
    else
    	echo "[WARNING!] It seems that your system does not have a Linux system service called 'avahi-daemon' installed!"
        echo "This service is mainly used for automatic discovery of NDI. KiloLink Server can work without this service, but the NDI|HX output you create in KiloLink Server will not be discovered by the system and may not even function properly."
        echo "As this is a system service, you need to MANUALLY install it. Note that different Linux distributions have different installation methods, typical of which are as follows:"
        echo
        echo "Ubuntu/Debian - "
        echo "    sudo apt install avahi-daemon"
        echo
        echo "CentOS/Fedora - "
        echo "    sudo yum install avahi-daemon"
        echo
        read -p "Are you sure to continue without 'avahi-daemon' service? [y/N]" CONFIRM
        if [ "$CONFIRM" = "y" -o "$CONFIRM" = "Y" ]; then
            no_avahi=y
        else
            echo
            exit 1
        fi
    fi

    echo
    echo "-------------------------------------------------"
    echo "#6. Creating docker container"
    echo "-------------------------------------------------"
    echo
    docker run -itd --name "$CONTAINER_NAME" \
        -e "web_port=${web_port}" \
        -e "server_port=${klnk_port}" \
        -e "stream_server_ip=${stream_server_ip}" \
        -e "stream_server_port=${stream_klnk_port}" \
        -v /var/run/avahi-daemon:/var/run/avahi-daemon \
        -v /var/run/dbus:/var/run/dbus \
        -v ${INSTALL_PATH}:/data \
        --restart=always \
        --network host \
        --privileged=true \
        ${REPO} \
        /bin/bash /start_server.sh

    if [ $? -eq 0 ]; then
        #Save the container name.
        echo "$CONTAINER_NAME" > "${INSTALL_PATH}/container.conf"
        echo
        echo "-------------------------------------"
        echo "Install KiloLink Server SUCCESSFULLY!"
        echo "-------------------------------------"
        echo
        echo "Please remember these access entrypoints:"
        echo
        echo "* Access http://$stream_server_ip:$web_port for web management."
        echo "* When you configure device to connects to the KiloLink Server, its IP is '$stream_server_ip' and access port is $klnk_port."
        echo "* Your docker container is named '$CONTAINER_NAME', you can use 'docker' commands to maintain it."
        echo
        if [ ! -z "$no_avahi" ]; then
            echo "Since without 'avahi-daemon' service install on your system, NDI discovery features will be disabled."
            echo
        fi
        echo "In addition, you also need to pay attention to checking your FIREWALL configuration, and at least ensure that the following ports are configured on the firewall to allow external access:"
        echo
        echo "* UDP ports: $klnk_port $stream_klnk_port"
        echo "* TCP ports: $web_port"
        echo
        echo "If you want to enable NDI|HX features:"
        echo "(the following var N represents how many NDI|HX streams you wish to allow)"
        echo
        echo "* UDP ports: 5353"
        echo "* TCP ports: [5961, 5962, ...(keep at least N ports open)]"
        echo "* TCP/UDP ports: 5960 [7960, 7961, ...(keep at least 4*N ports open)]"
        echo
        echo "For other protocols such as RTSP,SRT,webrtc,..., you also need to open the service port range [30000, 30300] as specified in the corresponding protocol."
        echo
        echo "ENJOY IT!"
        echo
    else
        echo "[ERROR!] Create docker container for KiloLink Server failed!" 
        echo
    fi
}

check_docker
install
exit 0
