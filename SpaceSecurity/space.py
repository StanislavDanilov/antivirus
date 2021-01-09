from include import *
client = MongoClient()
client = MongoClient('localhost', 27017)
db = client.security
result = db.result

def yarcat():
    if os.path.exists("./rules/output.yara") == True:
        os.remove("./rules/output.yara")
    with open("./rules/output.yara", "wb") as outfile:
        for root, dirs, files in os.walk("./rules", topdown=False):
            for name in files:
                fname = str(os.path.join(root, name))
                with open(fname, "rb") as infile:
                    if fname != './rules/output.txt':
                        outfile.write(infile.read())

def compileandscan(filematch):
    yarcat()
    print(filematch)
    rules = yara.compile('./rules/output.yara')
    matches = rules.match(filematch, timeout=60)
    ma = 0
    length = len(matches)
    if length > 0:
      c = matches
      dmatch = []
      for match in matches:
        dmatch.append(matches[ma].strings)
        ma = ma + 1
    else:
      matches = 'No virus is file.'
      dmatch = None
    return [matches, dmatch]

@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        print(request)
        file = request.files['file']
        if file and file != '':
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            return redirect(url_for('scan', filename=filename))
        else:
          return 'file blank. Please specifiy file'

    print(request.remote_addr)
    ip = request.remote_addr
    if result.find_one({"ip": ip}):
        print("есть в бд")
    else:
        ip_add_db = {"ip" : ip , "status" : "false"}
        result.insert_one(ip_add_db)
    return render_template('upload.html')

@app.route('/pefile', methods=['GET', 'POST'])
def upload_pefile():
    if request.method == 'POST':
        print(request)
        file = request.files['file']
        if file and file != '':
            filename_pe = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename_pe))
            return redirect(url_for('scanPe', filename_re=filename_pe))
        else:
          return 'file blank. Please specifiy files'
    return render_template('pefileUpload.html')

@app.route("/about")
def about():
  return render_template('about.html')

@app.route("/scan/<filename>")
def scan(filename):
    a = compileandscan('./uploads/' + filename)
    remdir = './uploads/' + filename
    ur = {'filename': filename, 'yararesults': a[0], 'yarastrings': a[1] , 'file': remdir, 'scan':'scan'}
    savedb = {'filename': filename,  'file': remdir, 'yarastrings': a[1], 'scan':'scan'}
    print(ur)
    result.insert_one(savedb)
    return render_template('results.html', ur=ur)

@app.route("/history", methods=["GET"])
def history():
    record = result.find({'scan': 'scan'})
    json_str = dumps(record)
   # print(json_str)
    return json_str

@app.route("/alertconnetion", methods=["GET"])
def alertconnetion():
    record = result.find({'status': 'false'})
    json_str = dumps(record)
   # print(json_str)
    return json_str

@app.route("/scanrefile/<filename_re>")
def scanPe(filename_re):
    remdir = './uploads/' + filename_re
    pe = pefile.PE(remdir)
    if hasattr(pe, 'DIRECTORY_ENTRY_IMPORT'):
      for dll_entry in pe.DIRECTORY_ENTRY_IMPORT:
        result_dll_file = dll_entry.dll.decode('utf-8')
        if re.search(r'\bADVARI32.dll\b', result_dll_file):
            print("Error")
            crypto = {'filename': filename_re, 'result': 'CryptoVirus', 'file': remdir, 'scan':'scan'}
            break
            result.insert_one(crypto)
        else:
            print("Good")
            crypto = {'filename': filename_re, 'result': 'No Virus', 'file': remdir, 'scan':'scan'}
      result.insert_one(crypto)
    return render_template('resultsPe.html', crypto=crypto)

@app.route("/checkIP")
def ipcheck():
    if result.find_one({'status' : 'true'}):
        return render_template('admin.html')
    else:
        return render_template('false.html')

@app.route("/requestiphone", methods=['GET', 'POST'])
def request1():
    if request.method == 'GET':
        ip = request.args.get('ip')
        status = request.args.get('status')
        if status == 'true':
            ip = {"ip" : ip}
            status = {"$set": {'status': "true"}}
            result.update_one(ip,status)
            print(list(result.find()))
        print()
        #отправка запроса на изменение http://localhost:3000/requestiphone?ip=127.0.0.1&status=true

@app.route("/add_coordinates", methods=['POST'])
def add_coordinates():
    data = request.get_json()
    print(data)
    id = 0
    for row in cur:
        id = row[0]
        print(id)
    k = 0
    try:
        for row in cur:
            k = len(row[0])
        print(k)
    except:
        k = 0
    print(data.get('coordinates_longitude'))
    print(data.get('coordinates_latitude'))

if __name__ == "__main__":
    app.run(host='0.0.0.0', port='3000')
