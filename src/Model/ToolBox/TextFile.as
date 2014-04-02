package Model.ToolBox
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class TextFile
	{
		public function TextFile()
		{
			
		}
		
		//      Writes the value parameter to file and replaces everything that was already in file (if existed)
		public static function write(value:String,target_url:String):void
		{
			//crates the new file class from string that contains target url...
			var file:File = new File(target_url);
			//creates the new FileStream class used to actualy write/read/... the file...
			var fs:FileStream = new FileStream();
			//opens the file in write method
			fs.open(file,FileMode.WRITE);
			//writes the text in file (UTFBytes are normal text...)
			fs.writeUTFBytes(value);
			//closes the file after it is done writing...
			fs.close();
		}
		
		//      function to read the text file starting with startIndex and ending with endIndex
		public static function read(target_url:String,startIndex:int = 0,endIndex:int = int.MAX_VALUE):String
		{
			var resaults:String;
			var file:File = new File(target_url);
			var fs:FileStream = new FileStream();
			//here we open the file in reading mode... you cannot write anything in the file while it is opened in this mode
			fs.open(file,FileMode.READ);
			//we move FileStream class to our startIndex, so that when we read something from the file it starts at startIndex and not at the begining of the file... ( if startIndex is 0 than that is the begining of the file)
			fs.position = startIndex;
			//we read the file and put it in resaults string... 
			//we have to pass how many bytes we want to read to readUTFBytes. If we pass grater number than there are avaliable bytes we will get an error. That is why we take the minimum from bytesAvaliable and diference between start and end index...
			resaults = fs.readUTFBytes(Math.min(endIndex-startIndex,fs.bytesAvailable));
			//after we have done everything we want we need to close the file...
			fs.close();
			//returns the string containing the text from startIndex to endIndex
			return resaults;
		}
		
		//      function used to append text to the end of text file. It is the same as write function, the only diference is that we open the file in APPEND mode and not WRITE. That means every time we write something AIR automatically writes that to the end of the file...
		public static function append(value:String,target_url:String):void
		{
			var file:File = new File(target_url);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.APPEND);
			fs.writeUTFBytes(value);
			fs.close();
		}
		//      function used to add text to desired position in file. It is the same as append, the diference is that we need to open file in UPDATE mode and we need to set position of our FileStream to desired position stored in startIndex parameter
		public static function update(value:String,target_url:String,startIndex:int = 0):void
		{
			var file:File = new File(target_url);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.UPDATE);
			fs.position = startIndex;
			fs.writeUTFBytes(value);
			fs.close();
		}
	}
}