# cordoav-plugin-glifile

function gli_file_put(path,data,type){
   glifile.write_file(successcallback,errorcallback,path,data);
}

function gli_file_get(path,type,callback){
   glifile.write_file(callback,callback,path);
}