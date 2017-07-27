cordova.define("cordova-plugin-glifile.GliFile", function(require, exports, module) {
var exec = cordova.require('cordova/exec');
var glifile={

	write_file:function(success,error,path,data){
	    exec(success,error,"GliFile","writefile",[path,data]);
	},

    get_folder:function(success,error,path){
        exec(success,error,"GliFile","getfoder",[path]);
     },

	read_file:function(success,error,path){
    	    exec(success,error,"GliFile","readfile",[path]);
	},
	
	download_file:function(success,error,url,path){
        exec(success,error,"GliFile","downloadfile",[url,path]);
    },
    delete_file:function(success,error,path){
        exec(success,error,"GliFile","deletefile",[path]);
    },
    exist_file:function(success,error,path){
        exec(success,error,"GliFile","existfile",[path]);
    },
    get_versionName:function(success,error){
        exec(success,error,"GliFile","getversionName",[]);
	},
    get_versioncode:function(success,error){
        exec(success,error,"GliFile","getversioncode",[]);
     }

}
module.exports=glifile;

});
