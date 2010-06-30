package views 
{
	import assets.AppSymbol;

	import data.UnicodeFont;

	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.RadioButton;
	import fl.data.DataProvider;
	import fl.managers.StyleManager;

	import koffee.utils.ArrayHelper;
	import koffee.utils.StringHelper;

	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.Font;
	import flash.text.TextFormat;

	/**
	 * @author Kevin Cao
	 */
	public class AppView extends AppSymbol 
	{
		public var bg : Sprite;

		public function AppView()
		{
			init();
//			update();
		}

		private function init() : void 
		{
			mouseEnabled = false;
			
			var defaultFmt : TextFormat = new TextFormat("_sans", 12, 0x0);
			var defaultDisabledFmt : TextFormat = new TextFormat("_sans", 12, 0x999999);
			
			StyleManager.setStyle("textFormat", defaultFmt);
			StyleManager.setStyle("disabledTextFormat", defaultDisabledFmt);
			
			StyleManager.setComponentStyle(RadioButton, "textFormat", new TextFormat("Microsoft YaHei", 11, 0x454545));
			StyleManager.setComponentStyle(CheckBox, "textFormat", new TextFormat("Microsoft YaHei", 11, 0x454545));
			StyleManager.setComponentStyle(CheckBox, "disabledTextFormat", new TextFormat("Microsoft YaHei", 11, 0x999999));
			StyleManager.setComponentStyle(Button, "textFormat", new TextFormat("Microsoft YaHei", 11, 0x454545));
			StyleManager.setComponentStyle(Button, "disabledTextFormat", new TextFormat("Microsoft YaHei", 11, 0x999999));
			StyleManager.setComponentStyle(RadioButton, "embedFonts", true);
			StyleManager.setComponentStyle(CheckBox, "embedFonts", true);
			StyleManager.setComponentStyle(Button, "embedFonts", true);
			
			input_ta.setStyle("textFormat", new TextFormat("Consolas,_typewriter", 12, 0x666666));
			output_ta.setStyle("textFormat", new TextFormat("Consolas,_typewriter", 12, 0x1f67bb));
			
			className_ti.setStyle("textPadding", 2);
			fontName_ti.setStyle("textPadding", 2);

			var dp : DataProvider = new DataProvider();
			var arr : Array = Font.enumerateFonts(true);
			arr.sortOn("fontName", Array.CASEINSENSITIVE);
			var n : int = arr.length;
			for (var i : int = 0;i < n;i++) 
			{
				dp.addItem({label:arr[i].fontName});
			}

			systemFont_cb.dataProvider = dp;
			systemFont_cb.rowCount = 10;
			systemFont_cb.selectedIndex = 0;
			
			systemFont_cb.dropdown.filters = [new DropShadowFilter(4, 45, 0, 0.6, 5, 5, 0.6, 2)];
			
			var ranges : XMLList = UnicodeFont.xml.range;
			var dp2 : DataProvider = new DataProvider();
			dp2.addItem({label:"无预设/所有字符", data:""});
			n = ranges.length();
			for (i = 0;i < n;i++) 
			{
				dp2.addItem({label:ranges[i].@name, data:ranges[i]});
			}
			
			range_list.dataProvider = dp2;
			range_list.selectedIndex = 0;
			
			preview_tf.borderColor = 0xcccccc;
			preview_tf.wordWrap = true;
			preview_tf.cacheAsBitmap = true;
			
			var shadow : DropShadowFilter = new DropShadowFilter(1, 45, 0, 0.4, 3, 3, 0.4, 2);
			import_btn.filters = [shadow];
			clear_btn.filters = [shadow];
			save_btn.filters = [shadow];
			clipboard_btn.filters = [shadow];
			compile_btn.filters = [shadow];
			
			bg = new Sprite();
			bg.graphics.beginFill(0xededed, 1);
			bg.graphics.drawRect(0, 0, 550, 680);
			bg.graphics.endFill();
			addChildAt(bg, 0);
		}

		public function update() : void 
		{		
			// aaa

			aaa_ck.enabled = !cff_ck.enabled || !cff_ck.selected;
			
			// font source

			externalFont_rb.selected = cff_ck.selected;
			
			var source : String;
			
			if(systemFont_rb.selected) 
			{
				systemFont_cb.enabled = true;
				fontPath_ti.enabled = false;
				browse_btn.enabled = false;
				source = 'systemFont="' + systemFont_cb.selectedLabel + '"';
				
				// update preview
				var preview_fmt : TextFormat = new TextFormat();
				preview_fmt.size = 30;
				preview_fmt.color = 0x444444;
				preview_fmt.align = "center";
				preview_fmt.font = systemFont_cb.selectedLabel;
				preview_fmt.bold = bold_ck.selected;
				preview_fmt.italic = italic_ck.selected;
				preview_tf.setTextFormat(preview_fmt);
				preview_tf.alpha = 1;
				preview_tf.mouseEnabled = true;
			}
			else 
			{
				systemFont_cb.enabled = false;
				fontPath_ti.enabled = true;
				browse_btn.enabled = true;
				source = 'source="' + StringHelper.trim(fontPath_ti.text) + '"';
				source = StringHelper.replace(source, "\\", "/");
				preview_tf.alpha = 0.5;
				preview_tf.mouseEnabled = false;
			}
			
			
			save_btn.enabled = !variable_rb.selected;
			compile_btn.enabled = !variable_rb.selected;
			
			
			// filter

			if(space_ck.selected) 
			{
				input_ta.text = StringHelper.replace(input_ta.text, "\n", "");
				input_ta.text = StringHelper.replace(input_ta.text, "\r", "");
				input_ta.text = StringHelper.replace(input_ta.text, " ", ""); // space
				input_ta.text = StringHelper.replace(input_ta.text, "	", ""); // tab
			}
			
			if(restrict_ck.selected) 
			{
				input_ta.text = filterNonChinese(input_ta.text);
			}
			
			
			
			// unicode range
			
			// 如果选择中包含第一项，则取消其他选择项
			if(range_list.selectedIndices.indexOf(0) != -1)
			{
				range_list.selectedIndex = 0;
			}

			var range : String = getUnicodeRange(input_ta.text);
			
			if(range_list.selectedIndex != -1 && range_list.selectedIndex != 0) 
			{
				var n : int = range_list.selectedItems.length;
				var array : Array = [];
				for (var i : int = 0;i < n;i++) 
				{
					array.push(range_list.selectedItems[i].data);
				}
				if(range != "")
				{
					range += "," + array.join(",");
				} 
				else 
				{
					range = array.join(",");
				}
			}
			
			// get options

			var options : Array = [];
			options[0] = source;
			options[1] = 'fontName="' + StringHelper.trim(fontName_ti.text) + '"';
			options[2] = italic_ck.selected ? 'fontStyle="italic"' : 'fontStyle="normal"';
			options[3] = bold_ck.selected ? 'fontWeight="bold"' : 'fontWeight="normal"';
			if(cff_ck.enabled)
			{
				options.push('embedAsCFF="' + cff_ck.selected + '"');
			}
			if(aaa_ck.enabled)
			{
				options.push('advancedAntiAliasing="' + aaa_ck.selected + '"');
			}
			if(range != "")
			{
				options.push('unicodeRange="' + range + '"');
			}
			
			
			// get template

			var template : String;
			
			if(variable_rb.selected) 
			{
				template = '[Embed({option}, mimeType="application/x-font")]\r';
				template += 'var {fontClass} : Class;';
			} 
			else 
			{
				template = 'package {\r';
				template += '	import flash.display.Sprite;\r';
				template += '	import flash.text.Font;\r\r';
				template += '	public class FontLibrary extends Sprite {\r';
				template += '		[Embed({option}, mimeType="application/x-font")]\r';
				template += '		static public var {fontClass} : Class;\r\r';
				template += '		public function FontLibrary() {\r';
				template += '			Font.registerFont({fontClass});\r';
				template += '		}\r	}\r}';
			}
			
			// convert

			template = StringHelper.replace(template, '{option}', options.join(", "));
			template = StringHelper.replace(template, '{fontClass}', className_ti.text);
			
			output_ta.text = template;
		}

		//----------------------------------
		//  helpers
		//----------------------------------

		private function getUnicodeRange(s : String) : String 
		{
			if(s == "") 
			{
				return "";
			}
			
			var a : Array = s.split('');
			var n : Number;
            
			a = ArrayHelper.removeDuplicates(a);
			
			for( var i : int = 0;i < a.length;i++ ) 
			{
				n = a[i].charCodeAt();
				a[i] = 'U+' + n.toString(16);
			}
			
			return a.join(",");
		}

		private function filterNonChinese(str : String) : String 
		{
			var pattern : RegExp = /[\u4e00-\u9fa5]/g;
			var results : Array = str.match(pattern);
			results = ArrayHelper.removeDuplicates(results);
			return results.join("");
		}
	}
}
