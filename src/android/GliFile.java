package org.apache.cordova.GliFile;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;


public class GliFile extends CordovaPlugin
{
	public void delFolder(String folderPath) {
		try {
			delAllFile(folderPath); //删除完里面所有内容
			String filePath = folderPath;
			filePath = filePath.toString();
			java.io.File myFilePath = new java.io.File(filePath);
			myFilePath.delete(); //删除空文件夹
		}
		catch (Exception e) {
			System.out.println("删除文件夹操作出错");
			e.printStackTrace();

		}
	}

	public void delAllFile(String path) {
		File file = new File(path);
		if (!file.exists()) {
			return;
		}
		if (!file.isDirectory()) {
			return;
		}
		String[] tempList = file.list();
		File temp = null;
		for (int i = 0; i < tempList.length; i++) {
			if (path.endsWith(File.separator)) {
				temp = new File(path + tempList[i]);
			}
			else {
				temp = new File(path + File.separator + tempList[i]);
			}
			if (temp.isFile()) {
				temp.delete();
			}
			if (temp.isDirectory()) {
				delAllFile(path+"/"+ tempList[i]);//先删除文件夹里面的文件
				delFolder(path+"/"+ tempList[i]);//再删除空文件夹
			}
		}
	}

	public String getAllFolder(String path) {

		String folderlist = "";
		File file = new File(path);
		if (!file.exists()) {
			return "";
		}
		if (!file.isDirectory()) {
			return "";
		}
		String[] tempList = file.list();
		File temp = null;
		for (int i = 0; i < tempList.length; i++) {
			if (path.endsWith(File.separator)) {
				temp = new File(path + tempList[i]);
			}
			else {
				temp = new File(path + File.separator + tempList[i]);
			}

			if (temp.isDirectory()) {
				//delAllFile(path+"/"+ tempList[i]);//先删除文件夹里面的文件
				//delFolder(path+"/"+ tempList[i]);//再删除空文件夹

				folderlist +=tempList[i];
				folderlist +=";";
			}
		}
		return folderlist;
	}

	public void wechattest (String filename,String data) {

		final String dirfile="download/books/test.txt";
		File sd= Environment.getExternalStorageDirectory();
		String path=sd.getPath()+"/Android/data/com.gli.scienceReaderOnline/files/"+dirfile.substring(0,dirfile.lastIndexOf("/"));
		String fileName=sd.getPath()+"/Android/data/com.gli.scienceReaderOnline/files/download/books"+filename;
		//String data = "123";
		File file=new File(path);
		if(!file.exists()) {
			file.mkdirs();
		}
		try {
			File files = new File(fileName);
			FileOutputStream fos = new FileOutputStream(files);
			byte [] bytes = data.getBytes();
			fos.write(bytes);
			fos.close();
			//PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, true);
			//pluginResult.setKeepCallback(true);
			//callbackContext.sendPluginResult(pluginResult);
		} catch (IOException e) {
			e.printStackTrace();
			//PluginResult pluginResult = new PluginResult(PluginResult.Status.ERROR, false);
			//pluginResult.setKeepCallback(true);
			//callbackContext.sendPluginResult(pluginResult);
		}


	}

	public boolean execute(String action,JSONArray args,final CallbackContext callbackContext) throws JSONException
	{
		if(action.equals("writefile"))
		{
			final String dirfile=args.getString(0);
			final String data=args.getString(1);
			final String packageNames = this.cordova.getActivity().getPackageName();
			cordova.getThreadPool().execute(new Runnable() {
				public void run() {
					File sd= Environment.getExternalStorageDirectory();
					String path=sd.getPath()+"/Android/data/"+packageNames+"/files/"+dirfile.substring(0,dirfile.lastIndexOf("/"));
					String fileName=sd.getPath()+"/Android/data/"+packageNames+"/files/"+dirfile;
					File file=new File(path);
					if(!file.exists()) {
						file.mkdirs();
					}
					try {
						File files = new File(fileName);
						FileOutputStream fos = new FileOutputStream(files);
						byte [] bytes = data.getBytes();
						fos.write(bytes);
						fos.close();
						PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, true);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
					} catch (IOException e) {
						e.printStackTrace();
						PluginResult pluginResult = new PluginResult(PluginResult.Status.ERROR, false);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
					}
				}
			});
			return true;
		}
		else if(action.equals("readfile"))
		{
			final String dirfile=args.getString(0);
			final String packageNames = this.cordova.getActivity().getPackageName();
			cordova.getThreadPool().execute(new Runnable() {
				public void run() {
					File sd= Environment.getExternalStorageDirectory();
					String fileName=sd.getPath()+"/Android/data/"+packageNames+"/files/"+dirfile;
					File file=new File(fileName);
					if(!file.exists()) {
						String call=null;
						PluginResult pluginResult = new PluginResult(PluginResult.Status.ERROR, call);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
						return;
					}
					try {
						File files = new File(fileName);
						FileInputStream fis = new FileInputStream(files);
						byte[] buffer = new byte[fis.available()];
						fis.read(buffer);
						String res = new String(buffer);
						fis.close();
						PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, res);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
					} catch (IOException e) {
						e.printStackTrace();
						String call=null;
						PluginResult pluginResult = new PluginResult(PluginResult.Status.ERROR, call);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
					}
				}
			});
			return true;
		}
		else if(action.equals("getversionName"))
		{
			PackageManager pm = this.cordova.getActivity().getPackageManager();
			PackageInfo pi = null;
			try {
				pi = pm.getPackageInfo(this.cordova.getActivity().getPackageName(), 0);
			} catch (PackageManager.NameNotFoundException e) {
				e.printStackTrace();
			}
			String versionName = pi.versionName;
			PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, versionName);
			pluginResult.setKeepCallback(true);
			callbackContext.sendPluginResult(pluginResult);
			return true;
		}
		else if(action.equals("getversioncode"))
		{
			PackageManager pm = this.cordova.getActivity().getPackageManager();
			PackageInfo pi = null;
			try {
				pi = pm.getPackageInfo(this.cordova.getActivity().getPackageName(), 0);
			} catch (PackageManager.NameNotFoundException e) {
				e.printStackTrace();
			}
			int versioncode = pi.versionCode;

			PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, versioncode);
			pluginResult.setKeepCallback(true);
			callbackContext.sendPluginResult(pluginResult);
			return true;
		}
		else if(action.equals("downloadfile"))
		{
			final String urlString=args.getString(0);
			final String path=args.getString(1);

			final String packageNames = this.cordova.getActivity().getPackageName();

			cordova.getThreadPool().execute(new Runnable() {
				public void run() {
					File sd= Environment.getExternalStorageDirectory();
					String ext=path.substring(path.lastIndexOf(".")+1);
					String fileName;
					String dirpath;
					int pos = path.indexOf("/Android");
					if(-1 == pos){
						fileName=sd.getPath()+"/Android/data/"+packageNames+"/files/"+path;
						dirpath=sd.getPath()+"/Android/data/"+packageNames+"/files/"+path.substring(0,path.lastIndexOf("/"));
					}else{
						fileName = path;
						dirpath=path.substring(0,path.lastIndexOf("/"));
					}

					File dfile=new File(dirpath);
					if(!dfile.exists()) {
						dfile.mkdirs();
					}
					try {
						URL url = new URL(urlString);
						HttpURLConnection conn = (HttpURLConnection) url.openConnection();
						conn.setConnectTimeout(5000);
						conn.setRequestMethod("GET");
						conn.setDoInput(true);
						if (conn.getResponseCode() == 200) {
							InputStream is = conn.getInputStream();
							FileOutputStream fos = new FileOutputStream(fileName+".temp");
							byte[] buffer = new byte[1024*4];
							int len = 0;
							while ((len = is.read(buffer)) != -1) {
								fos.write(buffer, 0, len);
							}
							is.close();
							fos.close();
							File oldfile =new File(fileName+".temp");
							File newfile =new File(fileName);

							boolean flag = oldfile.renameTo(newfile);
							if(flag){
								System.out.println("File renamed successfully");
								PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, true);
								pluginResult.setKeepCallback(true);
								callbackContext.sendPluginResult(pluginResult);
								return;
							}else{
								System.out.println("Rename operation failed");
							}

						}
						PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, false);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
						return;
					}
					catch (Exception e) {
						e.printStackTrace();
						PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, false);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
						return;
					}
				}
			});
			return true;
		}
		else if(action.equals("deletefile"))
		{
			final String packageNames = this.cordova.getActivity().getPackageName();
			final String path=args.getString(0);
			cordova.getThreadPool().execute(new Runnable() {
				public void run() {
					File sd = Environment.getExternalStorageDirectory();
					String file = sd.getPath() + "/Android/data/" + packageNames + "/files/" + path;
					File dfile=new File(file);
					if(dfile.exists()&&dfile.isFile()) {
						dfile.delete();
						PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, true);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
						return;
					}
					else if(dfile.exists()&&dfile.isDirectory())
					{
						delFolder(file);
						PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, true);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
						return;
					}
					else
					{
						PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, false);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
						return;
					}
				}
			});
			return true;
		}
		else if(action.equals("existfile"))
		{
			final String packageNames = this.cordova.getActivity().getPackageName();
			final String path=args.getString(0);
			cordova.getThreadPool().execute(new Runnable() {
				public void run() {
					File sd = Environment.getExternalStorageDirectory();
					String file = sd.getPath() + "/Android/data/" + packageNames + "/files/" + path;
					File dfile=new File(file);
					if (dfile.exists())
					{
						PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, true);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
					}
					else {
						PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, false);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
					}
				}
			});
			return true;
		}else if(action.equals("getfoder"))
		{
			final String packageNames = this.cordova.getActivity().getPackageName();
			final String path=args.getString(0);
			cordova.getThreadPool().execute(new Runnable() {
				public void run() {
					File sd = Environment.getExternalStorageDirectory();
					String file = sd.getPath() + "/Android/data/" + packageNames + "/files/" + path;
					File dfile=new File(file);
					if(dfile.exists()&&dfile.isDirectory())
					{
						String folder = getAllFolder(file);
						//String folder = "123,1215";
						PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, folder);
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
						return;
					}
					else
					{
						PluginResult pluginResult = new PluginResult(PluginResult.Status.ERROR, "");
						pluginResult.setKeepCallback(true);
						callbackContext.sendPluginResult(pluginResult);
						return;
					}
				}
			});
			return true;
		}
		return false;
	}
}
