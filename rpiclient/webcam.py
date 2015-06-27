import httplib
import io, sys
import time, datetime
import picamera
import httplib, urllib
import socket
import base64

httpserver='192.168.42.250'
httpurl="/upload.aspx?hostname="+socket.gethostname()

headers={"Content-type": "application/x-www-form-urlencoded", "Accept":"text/plain"}
params=urllib.urlencode({'client': socket.gethostname()})

failedUploads=[]

def uploadPicture(uuencoded):
	headers["Content-Length"] = len(uuencoded)
	conn=httplib.HTTPConnection(httpserver)
	print 'con',
	conn.request("POST", httpurl, uuencoded ,headers)
	print 'req',
	response=conn.getresponse()
	print response.status, response.reason,
	data=response.read()
	conn.close()


def takePicture(camera):
	try:
		camera.led=True
		camera.capture(jpgStream,'jpeg')
		iolen=jpgStream.tell()
		print 'cap ',iolen,
		jpgStream.seek(0)
		uuencoded=base64.b64encode(jpgStream.getvalue())
	except:
		print "exploded in capture"
	try:
		uploadPicture(uuencoded)
		camera.led=False
		# then try to upload anything that failed previously
		try:
			while (len(failedUploads)):
				uploadPicture(failedUploads.pop(0)['stream'])
				print "reuploaded"
		except:
			print "Unexpected error:", sys.exc_info()[0]
			print "reupload failed"
	except:
		failedUpload={ 'stream':jpgStream, 'timeTaken':datetime.datetime.utcnow()}
		failedUploads.append(failedUpload)
		print "exploded in http"


print 'starting ...'
# create a stream
jpgStream=io.BytesIO()
count=0
with picamera.PiCamera() as camera:
	camera.hflip = True
	camera.vflip = True
	camera.start_preview()
	camera.resolution = (1024, 768)
	time.sleep(2)
	while True:
		takePicture(camera)
		print 'completed ',count+1
		count=count+1
		time.sleep(60)

