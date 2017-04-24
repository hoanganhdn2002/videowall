###################################
# Author: Anh Le Hoang            #
# Email: hoanganhdn2002@gmail.com #
###################################
#!/usr/bin/python
# -*- coding: utf-8 -*- 
import time, os, sys, socket, getpass, requests, logging # import các module trong python
hostname = str(sys.argv[1])
homedir = os.environ['HOME'] # lấy đường dẫn home của máy (/home/vp9)
username = getpass.getuser() # lấy username của máy
path=os.path.join(homedir,hostname) # đường dẫn tới thư mục cần tạo
localtime = time.strftime("%d-%m-%Y_%H:%M:%S") # lấy thời gian của máy
user = 'vp9' # tài khoản đăng nhập vào client
HOST='vpn.'+hostname+'.vp9.tv' 
#************************** Khai báo các hàm dùng chung **************************#
def progressbar_network():
    for i in range(100001):
        s =  ((i/50000)*'.')
        print ('\rCheck network'+s),
pass

def progressbar_vpn():
    for i in range(100001):
        s =  ((i/9000)*'.')
        print ('\rCheck vpn'+s),
pass

def openimage(): # hàm mở ảnh sau khi chụp xong
    from PIL import Image
    #Read image
    im = Image.open(str(homedir)+'/'+str(hostname)+'/'+str(localtime)+'.jpg')
    #Display image
    im.show()
pass
# hàm kiểm tra mạng tại máy mình, nếu không có mạng sẽ tự động thoát chương trình
def checknetwork(url='http://www.google.com/', timeout=5):
    try:
        _ = requests.get(url, timeout=timeout)
        progressbar_network()
        print "online"
        return True
    except requests.ConnectionError:
        progressbar_network()
        print("offline")
        exit()
    return False
checknetwork()
# hàm kiểm tra vpn on/off, nếu không có vpn sẽ tự động thoát chương trình
def check_vpn():
    check = os.system('ping -c 1 %s' % HOST)
    if check == 0:
        progressbar_vpn()
        print "online"
        return True
    else:
        progressbar_vpn()
        print "offline"
        exit()
        return False
check_vpn()
# hàm chụp màn hình
# (1): Gửi lệnh chụp màn hình qua client.
# (2): Tải file ảnh vừa chụp từ client về máy mình.
# (3): Xóa ảnh vừa chụp ở client.
def screenshot():
    os.system("ssh "+user+"@vpn."+str(hostname)+".vp9.tv 'DISPLAY=:0.0 scrot "+str(homedir)+"/"+str(localtime)+".jpg'") #(1)
    os.system("cd " +str(homedir)+"/"+str(hostname)+"/ ;scp "+user+"@vpn."+str(hostname)+".vp9.tv:"+str(homedir)+"/"+str(localtime)+".jpg .") #(2)
    os.system("ssh "+user+"@vpn."+str(hostname)+".vp9.tv 'DISPLAY=:0.0 rm "+str(homedir)+"/"+str(localtime)+".jpg'") #(3)
pass

#*********************************************************************************#
# Kiểm tra điều kiện thư mục đã được tạo hay chưa
# Nếu thư mục đã được tạo thì sẽ chụp màn hình và mở image
# Nếu thư mục chưa tạo thì sẽ tạo thư mục và chụp màn hình và mở image
try:
    os.makedirs(path)
    print "Ảnh sẽ được lưu vào đường dẫn "+str(homedir)+"/"+str(hostname)+"/"
    screenshot() # Gọi hàm chụp ảnh
    openimage()
except OSError:
    print "Ảnh sẽ được lưu vào đường dẫn "+str(homedir)+"/"+str(hostname)+"/"
    screenshot()
    openimage()
else:
    print "Successful"