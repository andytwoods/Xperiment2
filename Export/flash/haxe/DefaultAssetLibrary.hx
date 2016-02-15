package;


import haxe.Timer;
import haxe.Unserializer;
import lime.app.Future;
import lime.app.Preloader;
import lime.app.Promise;
import lime.audio.AudioSource;
import lime.audio.openal.AL;
import lime.audio.AudioBuffer;
import lime.graphics.Image;
import lime.net.HTTPRequest;
import lime.system.CFFI;
import lime.text.Font;
import lime.utils.Bytes;
import lime.utils.UInt8Array;
import lime.Assets;

#if sys
import sys.FileSystem;
#end

#if flash
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLRequest;
#end


class DefaultAssetLibrary extends AssetLibrary {
	
	
	public var className (default, null) = new Map <String, Dynamic> ();
	public var path (default, null) = new Map <String, String> ();
	public var type (default, null) = new Map <String, AssetType> ();
	
	private var lastModified:Float;
	private var timer:Timer;
	
	
	public function new () {
		
		super ();
		
		#if (openfl && !flash)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		openfl.text.Font.registerFont (__ASSET__OPENFL__fonts_oxygen_bold_ttf);
		
		
		
		
		openfl.text.Font.registerFont (__ASSET__OPENFL__fonts_oxygen_ttf);
		
		
		
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_oxygen_bold_ttf);
		
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_oxygen_ttf);
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_img_square_ttf);
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		openfl.text.Font.registerFont (__ASSET__OPENFL__img_square_ttf);
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		#end
		
		#if flash
		
		className.set ("styles/default/circle.png", __ASSET__styles_default_circle_png);
		type.set ("styles/default/circle.png", AssetType.IMAGE);
		className.set ("styles/default/collapse.png", __ASSET__styles_default_collapse_png);
		type.set ("styles/default/collapse.png", AssetType.IMAGE);
		className.set ("styles/default/cross.png", __ASSET__styles_default_cross_png);
		type.set ("styles/default/cross.png", AssetType.IMAGE);
		className.set ("styles/default/expand.png", __ASSET__styles_default_expand_png);
		type.set ("styles/default/expand.png", AssetType.IMAGE);
		className.set ("styles/default/up_down.png", __ASSET__styles_default_up_down_png);
		type.set ("styles/default/up_down.png", AssetType.IMAGE);
		className.set ("styles/gradient/arrow_down.png", __ASSET__styles_gradient_arrow_down_png);
		type.set ("styles/gradient/arrow_down.png", AssetType.IMAGE);
		className.set ("styles/gradient/arrow_down_dark.png", __ASSET__styles_gradient_arrow_down_dark_png);
		type.set ("styles/gradient/arrow_down_dark.png", AssetType.IMAGE);
		className.set ("styles/gradient/arrow_down_disabled.png", __ASSET__styles_gradient_arrow_down_disabled_png);
		type.set ("styles/gradient/arrow_down_disabled.png", AssetType.IMAGE);
		className.set ("styles/gradient/arrow_left.png", __ASSET__styles_gradient_arrow_left_png);
		type.set ("styles/gradient/arrow_left.png", AssetType.IMAGE);
		className.set ("styles/gradient/arrow_left_disabled.png", __ASSET__styles_gradient_arrow_left_disabled_png);
		type.set ("styles/gradient/arrow_left_disabled.png", AssetType.IMAGE);
		className.set ("styles/gradient/arrow_right.png", __ASSET__styles_gradient_arrow_right_png);
		type.set ("styles/gradient/arrow_right.png", AssetType.IMAGE);
		className.set ("styles/gradient/arrow_right2.png", __ASSET__styles_gradient_arrow_right2_png);
		type.set ("styles/gradient/arrow_right2.png", AssetType.IMAGE);
		className.set ("styles/gradient/arrow_right_dark.png", __ASSET__styles_gradient_arrow_right_dark_png);
		type.set ("styles/gradient/arrow_right_dark.png", AssetType.IMAGE);
		className.set ("styles/gradient/arrow_right_disabled.png", __ASSET__styles_gradient_arrow_right_disabled_png);
		type.set ("styles/gradient/arrow_right_disabled.png", AssetType.IMAGE);
		className.set ("styles/gradient/arrow_up.png", __ASSET__styles_gradient_arrow_up_png);
		type.set ("styles/gradient/arrow_up.png", AssetType.IMAGE);
		className.set ("styles/gradient/arrow_up_disabled.png", __ASSET__styles_gradient_arrow_up_disabled_png);
		type.set ("styles/gradient/arrow_up_disabled.png", AssetType.IMAGE);
		className.set ("styles/gradient/circle_dark.png", __ASSET__styles_gradient_circle_dark_png);
		type.set ("styles/gradient/circle_dark.png", AssetType.IMAGE);
		className.set ("styles/gradient/cross_dark.png", __ASSET__styles_gradient_cross_dark_png);
		type.set ("styles/gradient/cross_dark.png", AssetType.IMAGE);
		className.set ("styles/gradient/cross_dark_disabled.png", __ASSET__styles_gradient_cross_dark_disabled_png);
		type.set ("styles/gradient/cross_dark_disabled.png", AssetType.IMAGE);
		className.set ("styles/gradient/cross_light_small.png", __ASSET__styles_gradient_cross_light_small_png);
		type.set ("styles/gradient/cross_light_small.png", AssetType.IMAGE);
		className.set ("styles/gradient/gradient.css", __ASSET__styles_gradient_gradient_css);
		type.set ("styles/gradient/gradient.css", AssetType.TEXT);
		className.set ("styles/gradient/gradient.min.css", __ASSET__styles_gradient_gradient_min_css);
		type.set ("styles/gradient/gradient.min.css", AssetType.TEXT);
		className.set ("styles/gradient/gradient_mobile.css", __ASSET__styles_gradient_gradient_mobile_css);
		type.set ("styles/gradient/gradient_mobile.css", AssetType.TEXT);
		className.set ("styles/gradient/gradient_mobile.min.css", __ASSET__styles_gradient_gradient_mobile_min_css);
		type.set ("styles/gradient/gradient_mobile.min.css", AssetType.TEXT);
		className.set ("styles/gradient/gripper_horizontal.png", __ASSET__styles_gradient_gripper_horizontal_png);
		type.set ("styles/gradient/gripper_horizontal.png", AssetType.IMAGE);
		className.set ("styles/gradient/gripper_horizontal_disabled.png", __ASSET__styles_gradient_gripper_horizontal_disabled_png);
		type.set ("styles/gradient/gripper_horizontal_disabled.png", AssetType.IMAGE);
		className.set ("styles/gradient/gripper_vertical.png", __ASSET__styles_gradient_gripper_vertical_png);
		type.set ("styles/gradient/gripper_vertical.png", AssetType.IMAGE);
		className.set ("styles/gradient/gripper_vertical_disabled.png", __ASSET__styles_gradient_gripper_vertical_disabled_png);
		type.set ("styles/gradient/gripper_vertical_disabled.png", AssetType.IMAGE);
		className.set ("styles/gradient/hsplitter_gripper.png", __ASSET__styles_gradient_hsplitter_gripper_png);
		type.set ("styles/gradient/hsplitter_gripper.png", AssetType.IMAGE);
		className.set ("styles/gradient/vsplitter_gripper.png", __ASSET__styles_gradient_vsplitter_gripper_png);
		type.set ("styles/gradient/vsplitter_gripper.png", AssetType.IMAGE);
		className.set ("styles/windows/accordion.css", __ASSET__styles_windows_accordion_css);
		type.set ("styles/windows/accordion.css", AssetType.TEXT);
		className.set ("styles/windows/accordion.min.css", __ASSET__styles_windows_accordion_min_css);
		type.set ("styles/windows/accordion.min.css", AssetType.TEXT);
		className.set ("styles/windows/button.png", __ASSET__styles_windows_button_png);
		type.set ("styles/windows/button.png", AssetType.IMAGE);
		className.set ("styles/windows/buttons.css", __ASSET__styles_windows_buttons_css);
		type.set ("styles/windows/buttons.css", AssetType.TEXT);
		className.set ("styles/windows/buttons.min.css", __ASSET__styles_windows_buttons_min_css);
		type.set ("styles/windows/buttons.min.css", AssetType.TEXT);
		className.set ("styles/windows/calendar.css", __ASSET__styles_windows_calendar_css);
		type.set ("styles/windows/calendar.css", AssetType.TEXT);
		className.set ("styles/windows/checkbox.png", __ASSET__styles_windows_checkbox_png);
		type.set ("styles/windows/checkbox.png", AssetType.IMAGE);
		className.set ("styles/windows/container.png", __ASSET__styles_windows_container_png);
		type.set ("styles/windows/container.png", AssetType.IMAGE);
		className.set ("styles/windows/glyphs/down_arrow.png", __ASSET__styles_windows_glyphs_down_arrow_png);
		type.set ("styles/windows/glyphs/down_arrow.png", AssetType.IMAGE);
		className.set ("styles/windows/glyphs/hscroll_thumb_gripper_down.png", __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_down_png);
		type.set ("styles/windows/glyphs/hscroll_thumb_gripper_down.png", AssetType.IMAGE);
		className.set ("styles/windows/glyphs/hscroll_thumb_gripper_over.png", __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_over_png);
		type.set ("styles/windows/glyphs/hscroll_thumb_gripper_over.png", AssetType.IMAGE);
		className.set ("styles/windows/glyphs/hscroll_thumb_gripper_up.png", __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_up_png);
		type.set ("styles/windows/glyphs/hscroll_thumb_gripper_up.png", AssetType.IMAGE);
		className.set ("styles/windows/glyphs/left_arrow.png", __ASSET__styles_windows_glyphs_left_arrow_png);
		type.set ("styles/windows/glyphs/left_arrow.png", AssetType.IMAGE);
		className.set ("styles/windows/glyphs/right_arrow.png", __ASSET__styles_windows_glyphs_right_arrow_png);
		type.set ("styles/windows/glyphs/right_arrow.png", AssetType.IMAGE);
		className.set ("styles/windows/glyphs/up_arrow.png", __ASSET__styles_windows_glyphs_up_arrow_png);
		type.set ("styles/windows/glyphs/up_arrow.png", AssetType.IMAGE);
		className.set ("styles/windows/glyphs/vscroll_thumb_gripper_down.png", __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_down_png);
		type.set ("styles/windows/glyphs/vscroll_thumb_gripper_down.png", AssetType.IMAGE);
		className.set ("styles/windows/glyphs/vscroll_thumb_gripper_over.png", __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_over_png);
		type.set ("styles/windows/glyphs/vscroll_thumb_gripper_over.png", AssetType.IMAGE);
		className.set ("styles/windows/glyphs/vscroll_thumb_gripper_up.png", __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_up_png);
		type.set ("styles/windows/glyphs/vscroll_thumb_gripper_up.png", AssetType.IMAGE);
		className.set ("styles/windows/hprogress.png", __ASSET__styles_windows_hprogress_png);
		type.set ("styles/windows/hprogress.png", AssetType.IMAGE);
		className.set ("styles/windows/hscroll.png", __ASSET__styles_windows_hscroll_png);
		type.set ("styles/windows/hscroll.png", AssetType.IMAGE);
		className.set ("styles/windows/listview.css", __ASSET__styles_windows_listview_css);
		type.set ("styles/windows/listview.css", AssetType.TEXT);
		className.set ("styles/windows/listview.min.css", __ASSET__styles_windows_listview_min_css);
		type.set ("styles/windows/listview.min.css", AssetType.TEXT);
		className.set ("styles/windows/listview.png", __ASSET__styles_windows_listview_png);
		type.set ("styles/windows/listview.png", AssetType.IMAGE);
		className.set ("styles/windows/menus.css", __ASSET__styles_windows_menus_css);
		type.set ("styles/windows/menus.css", AssetType.TEXT);
		className.set ("styles/windows/optionbox.png", __ASSET__styles_windows_optionbox_png);
		type.set ("styles/windows/optionbox.png", AssetType.IMAGE);
		className.set ("styles/windows/popup.png", __ASSET__styles_windows_popup_png);
		type.set ("styles/windows/popup.png", AssetType.IMAGE);
		className.set ("styles/windows/popups.css", __ASSET__styles_windows_popups_css);
		type.set ("styles/windows/popups.css", AssetType.TEXT);
		className.set ("styles/windows/rtf.css", __ASSET__styles_windows_rtf_css);
		type.set ("styles/windows/rtf.css", AssetType.TEXT);
		className.set ("styles/windows/scrolls.css", __ASSET__styles_windows_scrolls_css);
		type.set ("styles/windows/scrolls.css", AssetType.TEXT);
		className.set ("styles/windows/scrolls.min.css", __ASSET__styles_windows_scrolls_min_css);
		type.set ("styles/windows/scrolls.min.css", AssetType.TEXT);
		className.set ("styles/windows/sliders.css", __ASSET__styles_windows_sliders_css);
		type.set ("styles/windows/sliders.css", AssetType.TEXT);
		className.set ("styles/windows/tab.png", __ASSET__styles_windows_tab_png);
		type.set ("styles/windows/tab.png", AssetType.IMAGE);
		className.set ("styles/windows/tabs.css", __ASSET__styles_windows_tabs_css);
		type.set ("styles/windows/tabs.css", AssetType.TEXT);
		className.set ("styles/windows/textinput.png", __ASSET__styles_windows_textinput_png);
		type.set ("styles/windows/textinput.png", AssetType.IMAGE);
		className.set ("styles/windows/vprogress.png", __ASSET__styles_windows_vprogress_png);
		type.set ("styles/windows/vprogress.png", AssetType.IMAGE);
		className.set ("styles/windows/vscroll.png", __ASSET__styles_windows_vscroll_png);
		type.set ("styles/windows/vscroll.png", AssetType.IMAGE);
		className.set ("styles/windows/windows.css", __ASSET__styles_windows_windows_css);
		type.set ("styles/windows/windows.css", AssetType.TEXT);
		className.set ("fonts/Oxygen-Bold.eot", __ASSET__fonts_oxygen_bold_eot);
		type.set ("fonts/Oxygen-Bold.eot", AssetType.BINARY);
		className.set ("fonts/Oxygen-Bold.svg", __ASSET__fonts_oxygen_bold_svg);
		type.set ("fonts/Oxygen-Bold.svg", AssetType.TEXT);
		className.set ("fonts/Oxygen-Bold.ttf", __ASSET__fonts_oxygen_bold_ttf);
		type.set ("fonts/Oxygen-Bold.ttf", AssetType.FONT);
		className.set ("fonts/Oxygen-Bold.woff", __ASSET__fonts_oxygen_bold_woff);
		type.set ("fonts/Oxygen-Bold.woff", AssetType.BINARY);
		className.set ("fonts/Oxygen-Bold.woff2", __ASSET__fonts_oxygen_bold_woff2);
		type.set ("fonts/Oxygen-Bold.woff2", AssetType.BINARY);
		className.set ("fonts/Oxygen.eot", __ASSET__fonts_oxygen_eot);
		type.set ("fonts/Oxygen.eot", AssetType.BINARY);
		className.set ("fonts/Oxygen.svg", __ASSET__fonts_oxygen_svg);
		type.set ("fonts/Oxygen.svg", AssetType.TEXT);
		className.set ("fonts/Oxygen.ttf", __ASSET__fonts_oxygen_ttf);
		type.set ("fonts/Oxygen.ttf", AssetType.FONT);
		className.set ("fonts/Oxygen.woff", __ASSET__fonts_oxygen_woff);
		type.set ("fonts/Oxygen.woff", AssetType.BINARY);
		className.set ("fonts/Oxygen.woff2", __ASSET__fonts_oxygen_woff2);
		type.set ("fonts/Oxygen.woff2", AssetType.BINARY);
		className.set ("assets/data/countries.json", __ASSET__assets_data_countries_json);
		type.set ("assets/data/countries.json", AssetType.TEXT);
		className.set ("assets/fonts/Oxygen-Bold.ttf", __ASSET__assets_fonts_oxygen_bold_ttf);
		type.set ("assets/fonts/Oxygen-Bold.ttf", AssetType.FONT);
		className.set ("assets/fonts/Oxygen-Bold.woff", __ASSET__assets_fonts_oxygen_bold_woff);
		type.set ("assets/fonts/Oxygen-Bold.woff", AssetType.BINARY);
		className.set ("assets/fonts/Oxygen.ttf", __ASSET__assets_fonts_oxygen_ttf);
		type.set ("assets/fonts/Oxygen.ttf", AssetType.FONT);
		className.set ("assets/fonts/Oxygen.woff", __ASSET__assets_fonts_oxygen_woff);
		type.set ("assets/fonts/Oxygen.woff", AssetType.BINARY);
		className.set ("assets/html5/index.html", __ASSET__assets_html5_index_html);
		type.set ("assets/html5/index.html", AssetType.TEXT);
		className.set ("assets/img/icons/control-090.png", __ASSET__assets_img_icons_control_090_png);
		type.set ("assets/img/icons/control-090.png", AssetType.IMAGE);
		className.set ("assets/img/icons/control-180.png", __ASSET__assets_img_icons_control_180_png);
		type.set ("assets/img/icons/control-180.png", AssetType.IMAGE);
		className.set ("assets/img/icons/control-270.png", __ASSET__assets_img_icons_control_270_png);
		type.set ("assets/img/icons/control-270.png", AssetType.IMAGE);
		className.set ("assets/img/icons/control.png", __ASSET__assets_img_icons_control_png);
		type.set ("assets/img/icons/control.png", AssetType.IMAGE);
		className.set ("assets/img/icons/exclamation--frame.png", __ASSET__assets_img_icons_exclamation__frame_png);
		type.set ("assets/img/icons/exclamation--frame.png", AssetType.IMAGE);
		className.set ("assets/img/icons/exclamation-red-frame.png", __ASSET__assets_img_icons_exclamation_red_frame_png);
		type.set ("assets/img/icons/exclamation-red-frame.png", AssetType.IMAGE);
		className.set ("assets/img/icons/exclamation-red.png", __ASSET__assets_img_icons_exclamation_red_png);
		type.set ("assets/img/icons/exclamation-red.png", AssetType.IMAGE);
		className.set ("assets/img/icons/exclamation.png", __ASSET__assets_img_icons_exclamation_png);
		type.set ("assets/img/icons/exclamation.png", AssetType.IMAGE);
		className.set ("assets/img/icons/information-white.png", __ASSET__assets_img_icons_information_white_png);
		type.set ("assets/img/icons/information-white.png", AssetType.IMAGE);
		className.set ("assets/img/icons/lightning.png", __ASSET__assets_img_icons_lightning_png);
		type.set ("assets/img/icons/lightning.png", AssetType.IMAGE);
		className.set ("assets/img/icons/script-code.png", __ASSET__assets_img_icons_script_code_png);
		type.set ("assets/img/icons/script-code.png", AssetType.IMAGE);
		className.set ("assets/img/icons/ui-buttons.png", __ASSET__assets_img_icons_ui_buttons_png);
		type.set ("assets/img/icons/ui-buttons.png", AssetType.IMAGE);
		className.set ("assets/img/icons/ui-progress-bar-indeterminate.png", __ASSET__assets_img_icons_ui_progress_bar_indeterminate_png);
		type.set ("assets/img/icons/ui-progress-bar-indeterminate.png", AssetType.IMAGE);
		className.set ("assets/img/icons/ui-progress-bar.png", __ASSET__assets_img_icons_ui_progress_bar_png);
		type.set ("assets/img/icons/ui-progress-bar.png", AssetType.IMAGE);
		className.set ("assets/img/icons/user-nude-female.png", __ASSET__assets_img_icons_user_nude_female_png);
		type.set ("assets/img/icons/user-nude-female.png", AssetType.IMAGE);
		className.set ("assets/img/icons/user-nude.png", __ASSET__assets_img_icons_user_nude_png);
		type.set ("assets/img/icons/user-nude.png", AssetType.IMAGE);
		className.set ("assets/img/loaded.png", __ASSET__assets_img_loaded_png);
		type.set ("assets/img/loaded.png", AssetType.IMAGE);
		className.set ("assets/img/logo.png", __ASSET__assets_img_logo_png);
		type.set ("assets/img/logo.png", AssetType.IMAGE);
		className.set ("assets/img/logos/oxford01.png", __ASSET__assets_img_logos_oxford01_png);
		type.set ("assets/img/logos/oxford01.png", AssetType.IMAGE);
		className.set ("assets/img/logos/oxford02.png", __ASSET__assets_img_logos_oxford02_png);
		type.set ("assets/img/logos/oxford02.png", AssetType.IMAGE);
		className.set ("assets/img/openfl.svg", __ASSET__assets_img_openfl_svg);
		type.set ("assets/img/openfl.svg", AssetType.TEXT);
		className.set ("assets/img/square.ttf", __ASSET__assets_img_square_ttf);
		type.set ("assets/img/square.ttf", AssetType.FONT);
		className.set ("assets/openfl.svg", __ASSET__assets_openfl_svg);
		type.set ("assets/openfl.svg", AssetType.TEXT);
		className.set ("assets/themes/xpt/down_arrow.png", __ASSET__assets_themes_xpt_down_arrow_png);
		type.set ("assets/themes/xpt/down_arrow.png", AssetType.IMAGE);
		className.set ("assets/themes/xpt/down_arrow_white.png", __ASSET__assets_themes_xpt_down_arrow_white_png);
		type.set ("assets/themes/xpt/down_arrow_white.png", AssetType.IMAGE);
		className.set ("assets/themes/xpt/gripper_horizontal.png", __ASSET__assets_themes_xpt_gripper_horizontal_png);
		type.set ("assets/themes/xpt/gripper_horizontal.png", AssetType.IMAGE);
		className.set ("assets/themes/xpt/gripper_vertical.png", __ASSET__assets_themes_xpt_gripper_vertical_png);
		type.set ("assets/themes/xpt/gripper_vertical.png", AssetType.IMAGE);
		className.set ("assets/themes/xpt/left_arrow.png", __ASSET__assets_themes_xpt_left_arrow_png);
		type.set ("assets/themes/xpt/left_arrow.png", AssetType.IMAGE);
		className.set ("assets/themes/xpt/left_arrow_white.png", __ASSET__assets_themes_xpt_left_arrow_white_png);
		type.set ("assets/themes/xpt/left_arrow_white.png", AssetType.IMAGE);
		className.set ("assets/themes/xpt/right_arrow.png", __ASSET__assets_themes_xpt_right_arrow_png);
		type.set ("assets/themes/xpt/right_arrow.png", AssetType.IMAGE);
		className.set ("assets/themes/xpt/right_arrow_white.png", __ASSET__assets_themes_xpt_right_arrow_white_png);
		type.set ("assets/themes/xpt/right_arrow_white.png", AssetType.IMAGE);
		className.set ("assets/themes/xpt/up_arrow.png", __ASSET__assets_themes_xpt_up_arrow_png);
		type.set ("assets/themes/xpt/up_arrow.png", AssetType.IMAGE);
		className.set ("assets/themes/xpt/up_arrow_white.png", __ASSET__assets_themes_xpt_up_arrow_white_png);
		type.set ("assets/themes/xpt/up_arrow_white.png", AssetType.IMAGE);
		className.set ("assets/themes/xpt/up_down_arrows.png", __ASSET__assets_themes_xpt_up_down_arrows_png);
		type.set ("assets/themes/xpt/up_down_arrows.png", AssetType.IMAGE);
		className.set ("assets/themes/xpt/xpt.css", __ASSET__assets_themes_xpt_xpt_css);
		type.set ("assets/themes/xpt/xpt.css", AssetType.TEXT);
		className.set ("assets/themes/xpt/xpt.min.css", __ASSET__assets_themes_xpt_xpt_min_css);
		type.set ("assets/themes/xpt/xpt.min.css", AssetType.TEXT);
		className.set ("assets/ui/custom/number-stepper.xml", __ASSET__assets_ui_custom_number_stepper_xml);
		type.set ("assets/ui/custom/number-stepper.xml", AssetType.TEXT);
		className.set ("assets/ui/debug-window.xml", __ASSET__assets_ui_debug_window_xml);
		type.set ("assets/ui/debug-window.xml", AssetType.TEXT);
		className.set ("img/icons/control-090.png", __ASSET__img_icons_control_090_png);
		type.set ("img/icons/control-090.png", AssetType.IMAGE);
		className.set ("img/icons/control-180.png", __ASSET__img_icons_control_180_png);
		type.set ("img/icons/control-180.png", AssetType.IMAGE);
		className.set ("img/icons/control-270.png", __ASSET__img_icons_control_270_png);
		type.set ("img/icons/control-270.png", AssetType.IMAGE);
		className.set ("img/icons/control.png", __ASSET__img_icons_control_png);
		type.set ("img/icons/control.png", AssetType.IMAGE);
		className.set ("img/icons/exclamation--frame.png", __ASSET__img_icons_exclamation__frame_png);
		type.set ("img/icons/exclamation--frame.png", AssetType.IMAGE);
		className.set ("img/icons/exclamation-red-frame.png", __ASSET__img_icons_exclamation_red_frame_png);
		type.set ("img/icons/exclamation-red-frame.png", AssetType.IMAGE);
		className.set ("img/icons/exclamation-red.png", __ASSET__img_icons_exclamation_red_png);
		type.set ("img/icons/exclamation-red.png", AssetType.IMAGE);
		className.set ("img/icons/exclamation.png", __ASSET__img_icons_exclamation_png);
		type.set ("img/icons/exclamation.png", AssetType.IMAGE);
		className.set ("img/icons/information-white.png", __ASSET__img_icons_information_white_png);
		type.set ("img/icons/information-white.png", AssetType.IMAGE);
		className.set ("img/icons/lightning.png", __ASSET__img_icons_lightning_png);
		type.set ("img/icons/lightning.png", AssetType.IMAGE);
		className.set ("img/icons/script-code.png", __ASSET__img_icons_script_code_png);
		type.set ("img/icons/script-code.png", AssetType.IMAGE);
		className.set ("img/icons/ui-buttons.png", __ASSET__img_icons_ui_buttons_png);
		type.set ("img/icons/ui-buttons.png", AssetType.IMAGE);
		className.set ("img/icons/ui-progress-bar-indeterminate.png", __ASSET__img_icons_ui_progress_bar_indeterminate_png);
		type.set ("img/icons/ui-progress-bar-indeterminate.png", AssetType.IMAGE);
		className.set ("img/icons/ui-progress-bar.png", __ASSET__img_icons_ui_progress_bar_png);
		type.set ("img/icons/ui-progress-bar.png", AssetType.IMAGE);
		className.set ("img/icons/user-nude-female.png", __ASSET__img_icons_user_nude_female_png);
		type.set ("img/icons/user-nude-female.png", AssetType.IMAGE);
		className.set ("img/icons/user-nude.png", __ASSET__img_icons_user_nude_png);
		type.set ("img/icons/user-nude.png", AssetType.IMAGE);
		className.set ("img/loaded.png", __ASSET__img_loaded_png);
		type.set ("img/loaded.png", AssetType.IMAGE);
		className.set ("img/logo.png", __ASSET__img_logo_png);
		type.set ("img/logo.png", AssetType.IMAGE);
		className.set ("img/logos/oxford01.png", __ASSET__img_logos_oxford01_png);
		type.set ("img/logos/oxford01.png", AssetType.IMAGE);
		className.set ("img/logos/oxford02.png", __ASSET__img_logos_oxford02_png);
		type.set ("img/logos/oxford02.png", AssetType.IMAGE);
		className.set ("img/openfl.svg", __ASSET__img_openfl_svg);
		type.set ("img/openfl.svg", AssetType.TEXT);
		className.set ("img/square.ttf", __ASSET__img_square_ttf);
		type.set ("img/square.ttf", AssetType.FONT);
		className.set ("ui/custom/number-stepper.xml", __ASSET__ui_custom_number_stepper_xml);
		type.set ("ui/custom/number-stepper.xml", AssetType.TEXT);
		className.set ("ui/debug-window.xml", __ASSET__ui_debug_window_xml);
		type.set ("ui/debug-window.xml", AssetType.TEXT);
		className.set ("data/countries.json", __ASSET__data_countries_json);
		type.set ("data/countries.json", AssetType.TEXT);
		className.set ("themes/xpt/down_arrow.png", __ASSET__themes_xpt_down_arrow_png);
		type.set ("themes/xpt/down_arrow.png", AssetType.IMAGE);
		className.set ("themes/xpt/down_arrow_white.png", __ASSET__themes_xpt_down_arrow_white_png);
		type.set ("themes/xpt/down_arrow_white.png", AssetType.IMAGE);
		className.set ("themes/xpt/gripper_horizontal.png", __ASSET__themes_xpt_gripper_horizontal_png);
		type.set ("themes/xpt/gripper_horizontal.png", AssetType.IMAGE);
		className.set ("themes/xpt/gripper_vertical.png", __ASSET__themes_xpt_gripper_vertical_png);
		type.set ("themes/xpt/gripper_vertical.png", AssetType.IMAGE);
		className.set ("themes/xpt/left_arrow.png", __ASSET__themes_xpt_left_arrow_png);
		type.set ("themes/xpt/left_arrow.png", AssetType.IMAGE);
		className.set ("themes/xpt/left_arrow_white.png", __ASSET__themes_xpt_left_arrow_white_png);
		type.set ("themes/xpt/left_arrow_white.png", AssetType.IMAGE);
		className.set ("themes/xpt/right_arrow.png", __ASSET__themes_xpt_right_arrow_png);
		type.set ("themes/xpt/right_arrow.png", AssetType.IMAGE);
		className.set ("themes/xpt/right_arrow_white.png", __ASSET__themes_xpt_right_arrow_white_png);
		type.set ("themes/xpt/right_arrow_white.png", AssetType.IMAGE);
		className.set ("themes/xpt/up_arrow.png", __ASSET__themes_xpt_up_arrow_png);
		type.set ("themes/xpt/up_arrow.png", AssetType.IMAGE);
		className.set ("themes/xpt/up_arrow_white.png", __ASSET__themes_xpt_up_arrow_white_png);
		type.set ("themes/xpt/up_arrow_white.png", AssetType.IMAGE);
		className.set ("themes/xpt/up_down_arrows.png", __ASSET__themes_xpt_up_down_arrows_png);
		type.set ("themes/xpt/up_down_arrows.png", AssetType.IMAGE);
		className.set ("themes/xpt/xpt.css", __ASSET__themes_xpt_xpt_css);
		type.set ("themes/xpt/xpt.css", AssetType.TEXT);
		className.set ("themes/xpt/xpt.min.css", __ASSET__themes_xpt_xpt_min_css);
		type.set ("themes/xpt/xpt.min.css", AssetType.TEXT);
		
		
		#elseif html5
		
		var id;
		id = "styles/default/circle.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/default/collapse.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/default/cross.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/default/expand.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/default/up_down.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/arrow_down.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/arrow_down_dark.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/arrow_down_disabled.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/arrow_left.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/arrow_left_disabled.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/arrow_right.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/arrow_right2.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/arrow_right_dark.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/arrow_right_disabled.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/arrow_up.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/arrow_up_disabled.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/circle_dark.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/cross_dark.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/cross_dark_disabled.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/cross_light_small.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/gradient.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/gradient/gradient.min.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/gradient/gradient_mobile.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/gradient/gradient_mobile.min.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/gradient/gripper_horizontal.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/gripper_horizontal_disabled.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/gripper_vertical.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/gripper_vertical_disabled.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/hsplitter_gripper.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/gradient/vsplitter_gripper.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/accordion.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/accordion.min.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/button.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/buttons.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/buttons.min.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/calendar.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/checkbox.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/container.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/glyphs/down_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/glyphs/hscroll_thumb_gripper_down.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/glyphs/hscroll_thumb_gripper_over.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/glyphs/hscroll_thumb_gripper_up.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/glyphs/left_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/glyphs/right_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/glyphs/up_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/glyphs/vscroll_thumb_gripper_down.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/glyphs/vscroll_thumb_gripper_over.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/glyphs/vscroll_thumb_gripper_up.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/hprogress.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/hscroll.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/listview.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/listview.min.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/listview.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/menus.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/optionbox.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/popup.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/popups.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/rtf.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/scrolls.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/scrolls.min.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/sliders.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/tab.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/tabs.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "styles/windows/textinput.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/vprogress.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/vscroll.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "styles/windows/windows.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "fonts/Oxygen-Bold.eot";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "fonts/Oxygen-Bold.svg";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "fonts/Oxygen-Bold.ttf";
		className.set (id, __ASSET__fonts_oxygen_bold_ttf);
		
		type.set (id, AssetType.FONT);
		id = "fonts/Oxygen-Bold.woff";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "fonts/Oxygen-Bold.woff2";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "fonts/Oxygen.eot";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "fonts/Oxygen.svg";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "fonts/Oxygen.ttf";
		className.set (id, __ASSET__fonts_oxygen_ttf);
		
		type.set (id, AssetType.FONT);
		id = "fonts/Oxygen.woff";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "fonts/Oxygen.woff2";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "assets/data/countries.json";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/fonts/Oxygen-Bold.ttf";
		className.set (id, __ASSET__assets_fonts_oxygen_bold_ttf);
		
		type.set (id, AssetType.FONT);
		id = "assets/fonts/Oxygen-Bold.woff";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "assets/fonts/Oxygen.ttf";
		className.set (id, __ASSET__assets_fonts_oxygen_ttf);
		
		type.set (id, AssetType.FONT);
		id = "assets/fonts/Oxygen.woff";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "assets/html5/index.html";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/img/icons/control-090.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/control-180.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/control-270.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/control.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/exclamation--frame.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/exclamation-red-frame.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/exclamation-red.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/exclamation.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/information-white.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/lightning.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/script-code.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/ui-buttons.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/ui-progress-bar-indeterminate.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/ui-progress-bar.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/user-nude-female.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/icons/user-nude.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/loaded.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/logo.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/logos/oxford01.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/logos/oxford02.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/img/openfl.svg";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/img/square.ttf";
		className.set (id, __ASSET__assets_img_square_ttf);
		
		type.set (id, AssetType.FONT);
		id = "assets/openfl.svg";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/themes/xpt/down_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/themes/xpt/down_arrow_white.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/themes/xpt/gripper_horizontal.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/themes/xpt/gripper_vertical.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/themes/xpt/left_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/themes/xpt/left_arrow_white.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/themes/xpt/right_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/themes/xpt/right_arrow_white.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/themes/xpt/up_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/themes/xpt/up_arrow_white.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/themes/xpt/up_down_arrows.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/themes/xpt/xpt.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/themes/xpt/xpt.min.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/ui/custom/number-stepper.xml";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/ui/debug-window.xml";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "img/icons/control-090.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/control-180.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/control-270.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/control.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/exclamation--frame.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/exclamation-red-frame.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/exclamation-red.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/exclamation.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/information-white.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/lightning.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/script-code.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/ui-buttons.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/ui-progress-bar-indeterminate.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/ui-progress-bar.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/user-nude-female.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/icons/user-nude.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/loaded.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/logo.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/logos/oxford01.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/logos/oxford02.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/openfl.svg";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "img/square.ttf";
		className.set (id, __ASSET__img_square_ttf);
		
		type.set (id, AssetType.FONT);
		id = "ui/custom/number-stepper.xml";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "ui/debug-window.xml";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "data/countries.json";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "themes/xpt/down_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "themes/xpt/down_arrow_white.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "themes/xpt/gripper_horizontal.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "themes/xpt/gripper_vertical.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "themes/xpt/left_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "themes/xpt/left_arrow_white.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "themes/xpt/right_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "themes/xpt/right_arrow_white.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "themes/xpt/up_arrow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "themes/xpt/up_arrow_white.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "themes/xpt/up_down_arrows.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "themes/xpt/xpt.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "themes/xpt/xpt.min.css";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		
		
		var assetsPrefix = null;
		if (ApplicationMain.config != null && Reflect.hasField (ApplicationMain.config, "assetsPrefix")) {
			assetsPrefix = ApplicationMain.config.assetsPrefix;
		}
		if (assetsPrefix != null) {
			for (k in path.keys()) {
				path.set(k, assetsPrefix + path[k]);
			}
		}
		
		#else
		
		#if (windows || mac || linux)
		
		var useManifest = false;
		
		className.set ("styles/default/circle.png", __ASSET__styles_default_circle_png);
		type.set ("styles/default/circle.png", AssetType.IMAGE);
		
		className.set ("styles/default/collapse.png", __ASSET__styles_default_collapse_png);
		type.set ("styles/default/collapse.png", AssetType.IMAGE);
		
		className.set ("styles/default/cross.png", __ASSET__styles_default_cross_png);
		type.set ("styles/default/cross.png", AssetType.IMAGE);
		
		className.set ("styles/default/expand.png", __ASSET__styles_default_expand_png);
		type.set ("styles/default/expand.png", AssetType.IMAGE);
		
		className.set ("styles/default/up_down.png", __ASSET__styles_default_up_down_png);
		type.set ("styles/default/up_down.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/arrow_down.png", __ASSET__styles_gradient_arrow_down_png);
		type.set ("styles/gradient/arrow_down.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/arrow_down_dark.png", __ASSET__styles_gradient_arrow_down_dark_png);
		type.set ("styles/gradient/arrow_down_dark.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/arrow_down_disabled.png", __ASSET__styles_gradient_arrow_down_disabled_png);
		type.set ("styles/gradient/arrow_down_disabled.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/arrow_left.png", __ASSET__styles_gradient_arrow_left_png);
		type.set ("styles/gradient/arrow_left.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/arrow_left_disabled.png", __ASSET__styles_gradient_arrow_left_disabled_png);
		type.set ("styles/gradient/arrow_left_disabled.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/arrow_right.png", __ASSET__styles_gradient_arrow_right_png);
		type.set ("styles/gradient/arrow_right.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/arrow_right2.png", __ASSET__styles_gradient_arrow_right2_png);
		type.set ("styles/gradient/arrow_right2.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/arrow_right_dark.png", __ASSET__styles_gradient_arrow_right_dark_png);
		type.set ("styles/gradient/arrow_right_dark.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/arrow_right_disabled.png", __ASSET__styles_gradient_arrow_right_disabled_png);
		type.set ("styles/gradient/arrow_right_disabled.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/arrow_up.png", __ASSET__styles_gradient_arrow_up_png);
		type.set ("styles/gradient/arrow_up.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/arrow_up_disabled.png", __ASSET__styles_gradient_arrow_up_disabled_png);
		type.set ("styles/gradient/arrow_up_disabled.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/circle_dark.png", __ASSET__styles_gradient_circle_dark_png);
		type.set ("styles/gradient/circle_dark.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/cross_dark.png", __ASSET__styles_gradient_cross_dark_png);
		type.set ("styles/gradient/cross_dark.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/cross_dark_disabled.png", __ASSET__styles_gradient_cross_dark_disabled_png);
		type.set ("styles/gradient/cross_dark_disabled.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/cross_light_small.png", __ASSET__styles_gradient_cross_light_small_png);
		type.set ("styles/gradient/cross_light_small.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/gradient.css", __ASSET__styles_gradient_gradient_css);
		type.set ("styles/gradient/gradient.css", AssetType.TEXT);
		
		className.set ("styles/gradient/gradient.min.css", __ASSET__styles_gradient_gradient_min_css);
		type.set ("styles/gradient/gradient.min.css", AssetType.TEXT);
		
		className.set ("styles/gradient/gradient_mobile.css", __ASSET__styles_gradient_gradient_mobile_css);
		type.set ("styles/gradient/gradient_mobile.css", AssetType.TEXT);
		
		className.set ("styles/gradient/gradient_mobile.min.css", __ASSET__styles_gradient_gradient_mobile_min_css);
		type.set ("styles/gradient/gradient_mobile.min.css", AssetType.TEXT);
		
		className.set ("styles/gradient/gripper_horizontal.png", __ASSET__styles_gradient_gripper_horizontal_png);
		type.set ("styles/gradient/gripper_horizontal.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/gripper_horizontal_disabled.png", __ASSET__styles_gradient_gripper_horizontal_disabled_png);
		type.set ("styles/gradient/gripper_horizontal_disabled.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/gripper_vertical.png", __ASSET__styles_gradient_gripper_vertical_png);
		type.set ("styles/gradient/gripper_vertical.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/gripper_vertical_disabled.png", __ASSET__styles_gradient_gripper_vertical_disabled_png);
		type.set ("styles/gradient/gripper_vertical_disabled.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/hsplitter_gripper.png", __ASSET__styles_gradient_hsplitter_gripper_png);
		type.set ("styles/gradient/hsplitter_gripper.png", AssetType.IMAGE);
		
		className.set ("styles/gradient/vsplitter_gripper.png", __ASSET__styles_gradient_vsplitter_gripper_png);
		type.set ("styles/gradient/vsplitter_gripper.png", AssetType.IMAGE);
		
		className.set ("styles/windows/accordion.css", __ASSET__styles_windows_accordion_css);
		type.set ("styles/windows/accordion.css", AssetType.TEXT);
		
		className.set ("styles/windows/accordion.min.css", __ASSET__styles_windows_accordion_min_css);
		type.set ("styles/windows/accordion.min.css", AssetType.TEXT);
		
		className.set ("styles/windows/button.png", __ASSET__styles_windows_button_png);
		type.set ("styles/windows/button.png", AssetType.IMAGE);
		
		className.set ("styles/windows/buttons.css", __ASSET__styles_windows_buttons_css);
		type.set ("styles/windows/buttons.css", AssetType.TEXT);
		
		className.set ("styles/windows/buttons.min.css", __ASSET__styles_windows_buttons_min_css);
		type.set ("styles/windows/buttons.min.css", AssetType.TEXT);
		
		className.set ("styles/windows/calendar.css", __ASSET__styles_windows_calendar_css);
		type.set ("styles/windows/calendar.css", AssetType.TEXT);
		
		className.set ("styles/windows/checkbox.png", __ASSET__styles_windows_checkbox_png);
		type.set ("styles/windows/checkbox.png", AssetType.IMAGE);
		
		className.set ("styles/windows/container.png", __ASSET__styles_windows_container_png);
		type.set ("styles/windows/container.png", AssetType.IMAGE);
		
		className.set ("styles/windows/glyphs/down_arrow.png", __ASSET__styles_windows_glyphs_down_arrow_png);
		type.set ("styles/windows/glyphs/down_arrow.png", AssetType.IMAGE);
		
		className.set ("styles/windows/glyphs/hscroll_thumb_gripper_down.png", __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_down_png);
		type.set ("styles/windows/glyphs/hscroll_thumb_gripper_down.png", AssetType.IMAGE);
		
		className.set ("styles/windows/glyphs/hscroll_thumb_gripper_over.png", __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_over_png);
		type.set ("styles/windows/glyphs/hscroll_thumb_gripper_over.png", AssetType.IMAGE);
		
		className.set ("styles/windows/glyphs/hscroll_thumb_gripper_up.png", __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_up_png);
		type.set ("styles/windows/glyphs/hscroll_thumb_gripper_up.png", AssetType.IMAGE);
		
		className.set ("styles/windows/glyphs/left_arrow.png", __ASSET__styles_windows_glyphs_left_arrow_png);
		type.set ("styles/windows/glyphs/left_arrow.png", AssetType.IMAGE);
		
		className.set ("styles/windows/glyphs/right_arrow.png", __ASSET__styles_windows_glyphs_right_arrow_png);
		type.set ("styles/windows/glyphs/right_arrow.png", AssetType.IMAGE);
		
		className.set ("styles/windows/glyphs/up_arrow.png", __ASSET__styles_windows_glyphs_up_arrow_png);
		type.set ("styles/windows/glyphs/up_arrow.png", AssetType.IMAGE);
		
		className.set ("styles/windows/glyphs/vscroll_thumb_gripper_down.png", __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_down_png);
		type.set ("styles/windows/glyphs/vscroll_thumb_gripper_down.png", AssetType.IMAGE);
		
		className.set ("styles/windows/glyphs/vscroll_thumb_gripper_over.png", __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_over_png);
		type.set ("styles/windows/glyphs/vscroll_thumb_gripper_over.png", AssetType.IMAGE);
		
		className.set ("styles/windows/glyphs/vscroll_thumb_gripper_up.png", __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_up_png);
		type.set ("styles/windows/glyphs/vscroll_thumb_gripper_up.png", AssetType.IMAGE);
		
		className.set ("styles/windows/hprogress.png", __ASSET__styles_windows_hprogress_png);
		type.set ("styles/windows/hprogress.png", AssetType.IMAGE);
		
		className.set ("styles/windows/hscroll.png", __ASSET__styles_windows_hscroll_png);
		type.set ("styles/windows/hscroll.png", AssetType.IMAGE);
		
		className.set ("styles/windows/listview.css", __ASSET__styles_windows_listview_css);
		type.set ("styles/windows/listview.css", AssetType.TEXT);
		
		className.set ("styles/windows/listview.min.css", __ASSET__styles_windows_listview_min_css);
		type.set ("styles/windows/listview.min.css", AssetType.TEXT);
		
		className.set ("styles/windows/listview.png", __ASSET__styles_windows_listview_png);
		type.set ("styles/windows/listview.png", AssetType.IMAGE);
		
		className.set ("styles/windows/menus.css", __ASSET__styles_windows_menus_css);
		type.set ("styles/windows/menus.css", AssetType.TEXT);
		
		className.set ("styles/windows/optionbox.png", __ASSET__styles_windows_optionbox_png);
		type.set ("styles/windows/optionbox.png", AssetType.IMAGE);
		
		className.set ("styles/windows/popup.png", __ASSET__styles_windows_popup_png);
		type.set ("styles/windows/popup.png", AssetType.IMAGE);
		
		className.set ("styles/windows/popups.css", __ASSET__styles_windows_popups_css);
		type.set ("styles/windows/popups.css", AssetType.TEXT);
		
		className.set ("styles/windows/rtf.css", __ASSET__styles_windows_rtf_css);
		type.set ("styles/windows/rtf.css", AssetType.TEXT);
		
		className.set ("styles/windows/scrolls.css", __ASSET__styles_windows_scrolls_css);
		type.set ("styles/windows/scrolls.css", AssetType.TEXT);
		
		className.set ("styles/windows/scrolls.min.css", __ASSET__styles_windows_scrolls_min_css);
		type.set ("styles/windows/scrolls.min.css", AssetType.TEXT);
		
		className.set ("styles/windows/sliders.css", __ASSET__styles_windows_sliders_css);
		type.set ("styles/windows/sliders.css", AssetType.TEXT);
		
		className.set ("styles/windows/tab.png", __ASSET__styles_windows_tab_png);
		type.set ("styles/windows/tab.png", AssetType.IMAGE);
		
		className.set ("styles/windows/tabs.css", __ASSET__styles_windows_tabs_css);
		type.set ("styles/windows/tabs.css", AssetType.TEXT);
		
		className.set ("styles/windows/textinput.png", __ASSET__styles_windows_textinput_png);
		type.set ("styles/windows/textinput.png", AssetType.IMAGE);
		
		className.set ("styles/windows/vprogress.png", __ASSET__styles_windows_vprogress_png);
		type.set ("styles/windows/vprogress.png", AssetType.IMAGE);
		
		className.set ("styles/windows/vscroll.png", __ASSET__styles_windows_vscroll_png);
		type.set ("styles/windows/vscroll.png", AssetType.IMAGE);
		
		className.set ("styles/windows/windows.css", __ASSET__styles_windows_windows_css);
		type.set ("styles/windows/windows.css", AssetType.TEXT);
		
		className.set ("fonts/Oxygen-Bold.eot", __ASSET__fonts_oxygen_bold_eot);
		type.set ("fonts/Oxygen-Bold.eot", AssetType.BINARY);
		
		className.set ("fonts/Oxygen-Bold.svg", __ASSET__fonts_oxygen_bold_svg);
		type.set ("fonts/Oxygen-Bold.svg", AssetType.TEXT);
		
		className.set ("fonts/Oxygen-Bold.ttf", __ASSET__fonts_oxygen_bold_ttf);
		type.set ("fonts/Oxygen-Bold.ttf", AssetType.FONT);
		
		className.set ("fonts/Oxygen-Bold.woff", __ASSET__fonts_oxygen_bold_woff);
		type.set ("fonts/Oxygen-Bold.woff", AssetType.BINARY);
		
		className.set ("fonts/Oxygen-Bold.woff2", __ASSET__fonts_oxygen_bold_woff2);
		type.set ("fonts/Oxygen-Bold.woff2", AssetType.BINARY);
		
		className.set ("fonts/Oxygen.eot", __ASSET__fonts_oxygen_eot);
		type.set ("fonts/Oxygen.eot", AssetType.BINARY);
		
		className.set ("fonts/Oxygen.svg", __ASSET__fonts_oxygen_svg);
		type.set ("fonts/Oxygen.svg", AssetType.TEXT);
		
		className.set ("fonts/Oxygen.ttf", __ASSET__fonts_oxygen_ttf);
		type.set ("fonts/Oxygen.ttf", AssetType.FONT);
		
		className.set ("fonts/Oxygen.woff", __ASSET__fonts_oxygen_woff);
		type.set ("fonts/Oxygen.woff", AssetType.BINARY);
		
		className.set ("fonts/Oxygen.woff2", __ASSET__fonts_oxygen_woff2);
		type.set ("fonts/Oxygen.woff2", AssetType.BINARY);
		
		className.set ("assets/data/countries.json", __ASSET__assets_data_countries_json);
		type.set ("assets/data/countries.json", AssetType.TEXT);
		
		className.set ("assets/fonts/Oxygen-Bold.ttf", __ASSET__assets_fonts_oxygen_bold_ttf);
		type.set ("assets/fonts/Oxygen-Bold.ttf", AssetType.FONT);
		
		className.set ("assets/fonts/Oxygen-Bold.woff", __ASSET__assets_fonts_oxygen_bold_woff);
		type.set ("assets/fonts/Oxygen-Bold.woff", AssetType.BINARY);
		
		className.set ("assets/fonts/Oxygen.ttf", __ASSET__assets_fonts_oxygen_ttf);
		type.set ("assets/fonts/Oxygen.ttf", AssetType.FONT);
		
		className.set ("assets/fonts/Oxygen.woff", __ASSET__assets_fonts_oxygen_woff);
		type.set ("assets/fonts/Oxygen.woff", AssetType.BINARY);
		
		className.set ("assets/html5/index.html", __ASSET__assets_html5_index_html);
		type.set ("assets/html5/index.html", AssetType.TEXT);
		
		className.set ("assets/img/icons/control-090.png", __ASSET__assets_img_icons_control_090_png);
		type.set ("assets/img/icons/control-090.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/control-180.png", __ASSET__assets_img_icons_control_180_png);
		type.set ("assets/img/icons/control-180.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/control-270.png", __ASSET__assets_img_icons_control_270_png);
		type.set ("assets/img/icons/control-270.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/control.png", __ASSET__assets_img_icons_control_png);
		type.set ("assets/img/icons/control.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/exclamation--frame.png", __ASSET__assets_img_icons_exclamation__frame_png);
		type.set ("assets/img/icons/exclamation--frame.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/exclamation-red-frame.png", __ASSET__assets_img_icons_exclamation_red_frame_png);
		type.set ("assets/img/icons/exclamation-red-frame.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/exclamation-red.png", __ASSET__assets_img_icons_exclamation_red_png);
		type.set ("assets/img/icons/exclamation-red.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/exclamation.png", __ASSET__assets_img_icons_exclamation_png);
		type.set ("assets/img/icons/exclamation.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/information-white.png", __ASSET__assets_img_icons_information_white_png);
		type.set ("assets/img/icons/information-white.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/lightning.png", __ASSET__assets_img_icons_lightning_png);
		type.set ("assets/img/icons/lightning.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/script-code.png", __ASSET__assets_img_icons_script_code_png);
		type.set ("assets/img/icons/script-code.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/ui-buttons.png", __ASSET__assets_img_icons_ui_buttons_png);
		type.set ("assets/img/icons/ui-buttons.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/ui-progress-bar-indeterminate.png", __ASSET__assets_img_icons_ui_progress_bar_indeterminate_png);
		type.set ("assets/img/icons/ui-progress-bar-indeterminate.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/ui-progress-bar.png", __ASSET__assets_img_icons_ui_progress_bar_png);
		type.set ("assets/img/icons/ui-progress-bar.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/user-nude-female.png", __ASSET__assets_img_icons_user_nude_female_png);
		type.set ("assets/img/icons/user-nude-female.png", AssetType.IMAGE);
		
		className.set ("assets/img/icons/user-nude.png", __ASSET__assets_img_icons_user_nude_png);
		type.set ("assets/img/icons/user-nude.png", AssetType.IMAGE);
		
		className.set ("assets/img/loaded.png", __ASSET__assets_img_loaded_png);
		type.set ("assets/img/loaded.png", AssetType.IMAGE);
		
		className.set ("assets/img/logo.png", __ASSET__assets_img_logo_png);
		type.set ("assets/img/logo.png", AssetType.IMAGE);
		
		className.set ("assets/img/logos/oxford01.png", __ASSET__assets_img_logos_oxford01_png);
		type.set ("assets/img/logos/oxford01.png", AssetType.IMAGE);
		
		className.set ("assets/img/logos/oxford02.png", __ASSET__assets_img_logos_oxford02_png);
		type.set ("assets/img/logos/oxford02.png", AssetType.IMAGE);
		
		className.set ("assets/img/openfl.svg", __ASSET__assets_img_openfl_svg);
		type.set ("assets/img/openfl.svg", AssetType.TEXT);
		
		className.set ("assets/img/square.ttf", __ASSET__assets_img_square_ttf);
		type.set ("assets/img/square.ttf", AssetType.FONT);
		
		className.set ("assets/openfl.svg", __ASSET__assets_openfl_svg);
		type.set ("assets/openfl.svg", AssetType.TEXT);
		
		className.set ("assets/themes/xpt/down_arrow.png", __ASSET__assets_themes_xpt_down_arrow_png);
		type.set ("assets/themes/xpt/down_arrow.png", AssetType.IMAGE);
		
		className.set ("assets/themes/xpt/down_arrow_white.png", __ASSET__assets_themes_xpt_down_arrow_white_png);
		type.set ("assets/themes/xpt/down_arrow_white.png", AssetType.IMAGE);
		
		className.set ("assets/themes/xpt/gripper_horizontal.png", __ASSET__assets_themes_xpt_gripper_horizontal_png);
		type.set ("assets/themes/xpt/gripper_horizontal.png", AssetType.IMAGE);
		
		className.set ("assets/themes/xpt/gripper_vertical.png", __ASSET__assets_themes_xpt_gripper_vertical_png);
		type.set ("assets/themes/xpt/gripper_vertical.png", AssetType.IMAGE);
		
		className.set ("assets/themes/xpt/left_arrow.png", __ASSET__assets_themes_xpt_left_arrow_png);
		type.set ("assets/themes/xpt/left_arrow.png", AssetType.IMAGE);
		
		className.set ("assets/themes/xpt/left_arrow_white.png", __ASSET__assets_themes_xpt_left_arrow_white_png);
		type.set ("assets/themes/xpt/left_arrow_white.png", AssetType.IMAGE);
		
		className.set ("assets/themes/xpt/right_arrow.png", __ASSET__assets_themes_xpt_right_arrow_png);
		type.set ("assets/themes/xpt/right_arrow.png", AssetType.IMAGE);
		
		className.set ("assets/themes/xpt/right_arrow_white.png", __ASSET__assets_themes_xpt_right_arrow_white_png);
		type.set ("assets/themes/xpt/right_arrow_white.png", AssetType.IMAGE);
		
		className.set ("assets/themes/xpt/up_arrow.png", __ASSET__assets_themes_xpt_up_arrow_png);
		type.set ("assets/themes/xpt/up_arrow.png", AssetType.IMAGE);
		
		className.set ("assets/themes/xpt/up_arrow_white.png", __ASSET__assets_themes_xpt_up_arrow_white_png);
		type.set ("assets/themes/xpt/up_arrow_white.png", AssetType.IMAGE);
		
		className.set ("assets/themes/xpt/up_down_arrows.png", __ASSET__assets_themes_xpt_up_down_arrows_png);
		type.set ("assets/themes/xpt/up_down_arrows.png", AssetType.IMAGE);
		
		className.set ("assets/themes/xpt/xpt.css", __ASSET__assets_themes_xpt_xpt_css);
		type.set ("assets/themes/xpt/xpt.css", AssetType.TEXT);
		
		className.set ("assets/themes/xpt/xpt.min.css", __ASSET__assets_themes_xpt_xpt_min_css);
		type.set ("assets/themes/xpt/xpt.min.css", AssetType.TEXT);
		
		className.set ("assets/ui/custom/number-stepper.xml", __ASSET__assets_ui_custom_number_stepper_xml);
		type.set ("assets/ui/custom/number-stepper.xml", AssetType.TEXT);
		
		className.set ("assets/ui/debug-window.xml", __ASSET__assets_ui_debug_window_xml);
		type.set ("assets/ui/debug-window.xml", AssetType.TEXT);
		
		className.set ("img/icons/control-090.png", __ASSET__img_icons_control_090_png);
		type.set ("img/icons/control-090.png", AssetType.IMAGE);
		
		className.set ("img/icons/control-180.png", __ASSET__img_icons_control_180_png);
		type.set ("img/icons/control-180.png", AssetType.IMAGE);
		
		className.set ("img/icons/control-270.png", __ASSET__img_icons_control_270_png);
		type.set ("img/icons/control-270.png", AssetType.IMAGE);
		
		className.set ("img/icons/control.png", __ASSET__img_icons_control_png);
		type.set ("img/icons/control.png", AssetType.IMAGE);
		
		className.set ("img/icons/exclamation--frame.png", __ASSET__img_icons_exclamation__frame_png);
		type.set ("img/icons/exclamation--frame.png", AssetType.IMAGE);
		
		className.set ("img/icons/exclamation-red-frame.png", __ASSET__img_icons_exclamation_red_frame_png);
		type.set ("img/icons/exclamation-red-frame.png", AssetType.IMAGE);
		
		className.set ("img/icons/exclamation-red.png", __ASSET__img_icons_exclamation_red_png);
		type.set ("img/icons/exclamation-red.png", AssetType.IMAGE);
		
		className.set ("img/icons/exclamation.png", __ASSET__img_icons_exclamation_png);
		type.set ("img/icons/exclamation.png", AssetType.IMAGE);
		
		className.set ("img/icons/information-white.png", __ASSET__img_icons_information_white_png);
		type.set ("img/icons/information-white.png", AssetType.IMAGE);
		
		className.set ("img/icons/lightning.png", __ASSET__img_icons_lightning_png);
		type.set ("img/icons/lightning.png", AssetType.IMAGE);
		
		className.set ("img/icons/script-code.png", __ASSET__img_icons_script_code_png);
		type.set ("img/icons/script-code.png", AssetType.IMAGE);
		
		className.set ("img/icons/ui-buttons.png", __ASSET__img_icons_ui_buttons_png);
		type.set ("img/icons/ui-buttons.png", AssetType.IMAGE);
		
		className.set ("img/icons/ui-progress-bar-indeterminate.png", __ASSET__img_icons_ui_progress_bar_indeterminate_png);
		type.set ("img/icons/ui-progress-bar-indeterminate.png", AssetType.IMAGE);
		
		className.set ("img/icons/ui-progress-bar.png", __ASSET__img_icons_ui_progress_bar_png);
		type.set ("img/icons/ui-progress-bar.png", AssetType.IMAGE);
		
		className.set ("img/icons/user-nude-female.png", __ASSET__img_icons_user_nude_female_png);
		type.set ("img/icons/user-nude-female.png", AssetType.IMAGE);
		
		className.set ("img/icons/user-nude.png", __ASSET__img_icons_user_nude_png);
		type.set ("img/icons/user-nude.png", AssetType.IMAGE);
		
		className.set ("img/loaded.png", __ASSET__img_loaded_png);
		type.set ("img/loaded.png", AssetType.IMAGE);
		
		className.set ("img/logo.png", __ASSET__img_logo_png);
		type.set ("img/logo.png", AssetType.IMAGE);
		
		className.set ("img/logos/oxford01.png", __ASSET__img_logos_oxford01_png);
		type.set ("img/logos/oxford01.png", AssetType.IMAGE);
		
		className.set ("img/logos/oxford02.png", __ASSET__img_logos_oxford02_png);
		type.set ("img/logos/oxford02.png", AssetType.IMAGE);
		
		className.set ("img/openfl.svg", __ASSET__img_openfl_svg);
		type.set ("img/openfl.svg", AssetType.TEXT);
		
		className.set ("img/square.ttf", __ASSET__img_square_ttf);
		type.set ("img/square.ttf", AssetType.FONT);
		
		className.set ("ui/custom/number-stepper.xml", __ASSET__ui_custom_number_stepper_xml);
		type.set ("ui/custom/number-stepper.xml", AssetType.TEXT);
		
		className.set ("ui/debug-window.xml", __ASSET__ui_debug_window_xml);
		type.set ("ui/debug-window.xml", AssetType.TEXT);
		
		className.set ("data/countries.json", __ASSET__data_countries_json);
		type.set ("data/countries.json", AssetType.TEXT);
		
		className.set ("themes/xpt/down_arrow.png", __ASSET__themes_xpt_down_arrow_png);
		type.set ("themes/xpt/down_arrow.png", AssetType.IMAGE);
		
		className.set ("themes/xpt/down_arrow_white.png", __ASSET__themes_xpt_down_arrow_white_png);
		type.set ("themes/xpt/down_arrow_white.png", AssetType.IMAGE);
		
		className.set ("themes/xpt/gripper_horizontal.png", __ASSET__themes_xpt_gripper_horizontal_png);
		type.set ("themes/xpt/gripper_horizontal.png", AssetType.IMAGE);
		
		className.set ("themes/xpt/gripper_vertical.png", __ASSET__themes_xpt_gripper_vertical_png);
		type.set ("themes/xpt/gripper_vertical.png", AssetType.IMAGE);
		
		className.set ("themes/xpt/left_arrow.png", __ASSET__themes_xpt_left_arrow_png);
		type.set ("themes/xpt/left_arrow.png", AssetType.IMAGE);
		
		className.set ("themes/xpt/left_arrow_white.png", __ASSET__themes_xpt_left_arrow_white_png);
		type.set ("themes/xpt/left_arrow_white.png", AssetType.IMAGE);
		
		className.set ("themes/xpt/right_arrow.png", __ASSET__themes_xpt_right_arrow_png);
		type.set ("themes/xpt/right_arrow.png", AssetType.IMAGE);
		
		className.set ("themes/xpt/right_arrow_white.png", __ASSET__themes_xpt_right_arrow_white_png);
		type.set ("themes/xpt/right_arrow_white.png", AssetType.IMAGE);
		
		className.set ("themes/xpt/up_arrow.png", __ASSET__themes_xpt_up_arrow_png);
		type.set ("themes/xpt/up_arrow.png", AssetType.IMAGE);
		
		className.set ("themes/xpt/up_arrow_white.png", __ASSET__themes_xpt_up_arrow_white_png);
		type.set ("themes/xpt/up_arrow_white.png", AssetType.IMAGE);
		
		className.set ("themes/xpt/up_down_arrows.png", __ASSET__themes_xpt_up_down_arrows_png);
		type.set ("themes/xpt/up_down_arrows.png", AssetType.IMAGE);
		
		className.set ("themes/xpt/xpt.css", __ASSET__themes_xpt_xpt_css);
		type.set ("themes/xpt/xpt.css", AssetType.TEXT);
		
		className.set ("themes/xpt/xpt.min.css", __ASSET__themes_xpt_xpt_min_css);
		type.set ("themes/xpt/xpt.min.css", AssetType.TEXT);
		
		
		if (useManifest) {
			
			loadManifest ();
			
			if (Sys.args ().indexOf ("-livereload") > -1) {
				
				var path = FileSystem.fullPath ("manifest");
				lastModified = FileSystem.stat (path).mtime.getTime ();
				
				timer = new Timer (2000);
				timer.run = function () {
					
					var modified = FileSystem.stat (path).mtime.getTime ();
					
					if (modified > lastModified) {
						
						lastModified = modified;
						loadManifest ();
						
						onChange.dispatch ();
						
					}
					
				}
				
			}
			
		}
		
		#else
		
		loadManifest ();
		
		#end
		#end
		
	}
	
	
	public override function exists (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var assetType = this.type.get (id);
		
		if (assetType != null) {
			
			if (assetType == requestedType || ((requestedType == SOUND || requestedType == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if (requestedType == BINARY && (assetType == BINARY || assetType == TEXT || assetType == IMAGE)) {
				
				return true;
				
			} else if (requestedType == TEXT && assetType == BINARY) {
				
				return true;
				
			} else if (requestedType == null || path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (requestedType == BINARY || requestedType == null || (assetType == BINARY && requestedType == TEXT)) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getAudioBuffer (id:String):AudioBuffer {
		
		#if flash
		
		var buffer = new AudioBuffer ();
		buffer.src = cast (Type.createInstance (className.get (id), []), Sound);
		return buffer;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		if (className.exists(id)) return AudioBuffer.fromBytes (cast (Type.createInstance (className.get (id), []), Bytes));
		else return AudioBuffer.fromFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):Bytes {
		
		#if flash
		
		switch (type.get (id)) {
			
			case TEXT, BINARY:
				
				return Bytes.ofData (cast (Type.createInstance (className.get (id), []), flash.utils.ByteArray));
			
			case IMAGE:
				
				var bitmapData = cast (Type.createInstance (className.get (id), []), BitmapData);
				return Bytes.ofData (bitmapData.getPixels (bitmapData.rect));
			
			default:
				
				return null;
			
		}
		
		return cast (Type.createInstance (className.get (id), []), Bytes);
		
		#elseif html5
		
		var loader = Preloader.loaders.get (path.get (id));
		
		if (loader == null) {
			
			return null;
			
		}
		
		var bytes = loader.bytes;
		
		if (bytes != null) {
			
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Bytes);
		else return Bytes.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if flash
		
		var src = Type.createInstance (className.get (id), []);
		
		var font = new Font (src.fontName);
		font.src = src;
		return font;
		
		#elseif html5
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Font);
			
		} else {
			
			return Font.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	public override function getImage (id:String):Image {
		
		#if flash
		
		return Image.fromBitmapData (cast (Type.createInstance (className.get (id), []), BitmapData));
		
		#elseif html5
		
		return Image.fromImageElement (Preloader.images.get (path.get (id)));
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Image);
			
		} else {
			
			return Image.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	/*public override function getMusic (id:String):Dynamic {
		
		#if flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif openfl_html5
		
		//var sound = new Sound ();
		//sound.__buffer = true;
		//sound.load (new URLRequest (path.get (id)));
		//return sound;
		return null;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return null;
		//if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		//else return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}*/
	
	
	public override function getPath (id:String):String {
		
		//#if ios
		
		//return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		//#else
		
		return path.get (id);
		
		//#end
		
	}
	
	
	public override function getText (id:String):String {
		
		#if html5
		
		var loader = Preloader.loaders.get (path.get (id));
		
		if (loader == null) {
			
			return null;
			
		}
		
		var bytes = loader.bytes;
		
		if (bytes != null) {
			
			return bytes.getString (0, bytes.length);
			
		} else {
			
			return null;
		}
		
		#else
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.getString (0, bytes.length);
			
		}
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		
		#if flash
		
		//if (requestedType != AssetType.MUSIC && requestedType != AssetType.SOUND) {
			
			return className.exists (id);
			
		//}
		
		#end
		
		return true;
		
	}
	
	
	public override function list (type:String):Array<String> {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var items = [];
		
		for (id in this.type.keys ()) {
			
			if (requestedType == null || exists (id, type)) {
				
				items.push (id);
				
			}
			
		}
		
		return items;
		
	}
	
	
	public override function loadAudioBuffer (id:String):Future<AudioBuffer> {
		
		var promise = new Promise<AudioBuffer> ();
		
		#if (flash)
		
		if (path.exists (id)) {
			
			var soundLoader = new Sound ();
			soundLoader.addEventListener (Event.COMPLETE, function (event) {
				
				var audioBuffer:AudioBuffer = new AudioBuffer();
				audioBuffer.src = event.currentTarget;
				promise.complete (audioBuffer);
				
			});
			soundLoader.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			soundLoader.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			soundLoader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getAudioBuffer (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<AudioBuffer> (function () return getAudioBuffer (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	public override function loadBytes (id:String):Future<Bytes> {
		
		var promise = new Promise<Bytes> ();
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = Bytes.ofString (event.currentTarget.data);
				promise.complete (bytes);
				
			});
			loader.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			loader.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getBytes (id));
			
		}
		
		#elseif html5
		
		if (path.exists (id)) {
			
			var request = new HTTPRequest ();
			promise.completeWith (request.load (path.get (id) + "?" + Assets.cache.version));
			
		} else {
			
			promise.complete (getBytes (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<Bytes> (function () return getBytes (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	public override function loadImage (id:String):Future<Image> {
		
		var promise = new Promise<Image> ();
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bitmapData = cast (event.currentTarget.content, Bitmap).bitmapData;
				promise.complete (Image.fromBitmapData (bitmapData));
				
			});
			loader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getImage (id));
			
		}
		
		#elseif html5
		
		if (path.exists (id)) {
			
			var image = new js.html.Image ();
			image.onload = function (_):Void {
				
				promise.complete (Image.fromImageElement (image));
				
			}
			image.onerror = promise.error;
			image.src = path.get (id) + "?" + Assets.cache.version;
			
		} else {
			
			promise.complete (getImage (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<Image> (function () return getImage (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	#if (!flash && !html5)
	private function loadManifest ():Void {
		
		try {
			
			#if blackberry
			var bytes = Bytes.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = Bytes.readFile ("../res/manifest");
			#elseif emscripten
			var bytes = Bytes.readFile ("assets/manifest");
			#elseif (mac && java)
			var bytes = Bytes.readFile ("../Resources/manifest");
			#elseif (ios || tvos)
			var bytes = Bytes.readFile ("assets/manifest");
			#else
			var bytes = Bytes.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				if (bytes.length > 0) {
					
					var data = bytes.getString (0, bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<Dynamic> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							if (!className.exists (asset.id)) {
								
								#if (ios || tvos)
								path.set (asset.id, "assets/" + asset.path);
								#else
								path.set (asset.id, asset.path);
								#end
								type.set (asset.id, cast (asset.type, AssetType));
								
							}
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest (bytes was null)");
				
			}
		
		} catch (e:Dynamic) {
			
			trace ('Warning: Could not load asset manifest (${e})');
			
		}
		
	}
	#end
	
	
	public override function loadText (id:String):Future<String> {
		
		var promise = new Promise<String> ();
		
		#if html5
		
		if (path.exists (id)) {
			
			var request = new HTTPRequest ();
			var future = request.load (path.get (id) + "?" + Assets.cache.version);
			future.onProgress (function (progress) promise.progress (progress));
			future.onError (function (msg) promise.error (msg));
			future.onComplete (function (bytes) promise.complete (bytes.getString (0, bytes.length)));
			
		} else {
			
			promise.complete (getText (id));
			
		}
		
		#else
		
		promise.completeWith (loadBytes (id).then (function (bytes) {
			
			return new Future<String> (function () {
				
				if (bytes == null) {
					
					return null;
					
				} else {
					
					return bytes.getString (0, bytes.length);
					
				}
				
			});
			
		}));
		
		#end
		
		return promise.future;
		
	}
	
	
}


#if !display
#if flash

@:keep @:bind #if display private #end class __ASSET__styles_default_circle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_default_collapse_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_default_cross_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_default_expand_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_default_up_down_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_arrow_down_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_arrow_down_dark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_arrow_down_disabled_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_arrow_left_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_arrow_left_disabled_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_arrow_right_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_arrow_right2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_arrow_right_dark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_arrow_right_disabled_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_arrow_up_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_arrow_up_disabled_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_circle_dark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_cross_dark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_cross_dark_disabled_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_cross_light_small_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_gradient_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_gradient_min_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_gradient_mobile_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_gradient_mobile_min_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_gripper_horizontal_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_gripper_horizontal_disabled_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_gripper_vertical_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_gripper_vertical_disabled_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_hsplitter_gripper_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_gradient_vsplitter_gripper_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_accordion_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_accordion_min_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_buttons_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_buttons_min_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_calendar_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_checkbox_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_container_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_glyphs_down_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_down_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_over_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_up_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_glyphs_left_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_glyphs_right_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_glyphs_up_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_down_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_over_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_up_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_hprogress_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_hscroll_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_listview_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_listview_min_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_listview_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_menus_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_optionbox_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_popup_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_popups_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_rtf_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_scrolls_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_scrolls_min_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_sliders_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_tab_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_tabs_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__styles_windows_textinput_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_vprogress_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_vscroll_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__styles_windows_windows_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__fonts_oxygen_bold_eot extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__fonts_oxygen_bold_svg extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__fonts_oxygen_bold_ttf extends flash.text.Font { }
@:keep @:bind #if display private #end class __ASSET__fonts_oxygen_bold_woff extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__fonts_oxygen_bold_woff2 extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__fonts_oxygen_eot extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__fonts_oxygen_svg extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__fonts_oxygen_ttf extends flash.text.Font { }
@:keep @:bind #if display private #end class __ASSET__fonts_oxygen_woff extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__fonts_oxygen_woff2 extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_data_countries_json extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_fonts_oxygen_bold_ttf extends flash.text.Font { }
@:keep @:bind #if display private #end class __ASSET__assets_fonts_oxygen_bold_woff extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_fonts_oxygen_ttf extends flash.text.Font { }
@:keep @:bind #if display private #end class __ASSET__assets_fonts_oxygen_woff extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_html5_index_html extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_control_090_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_control_180_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_control_270_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_control_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_exclamation__frame_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_exclamation_red_frame_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_exclamation_red_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_exclamation_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_information_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_lightning_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_script_code_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_ui_buttons_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_ui_progress_bar_indeterminate_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_ui_progress_bar_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_user_nude_female_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_icons_user_nude_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_loaded_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_logo_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_logos_oxford01_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_logos_oxford02_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_img_openfl_svg extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_img_square_ttf extends flash.text.Font { }
@:keep @:bind #if display private #end class __ASSET__assets_openfl_svg extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_down_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_down_arrow_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_gripper_horizontal_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_gripper_vertical_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_left_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_left_arrow_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_right_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_right_arrow_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_up_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_up_arrow_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_up_down_arrows_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_xpt_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_themes_xpt_xpt_min_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_ui_custom_number_stepper_xml extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_ui_debug_window_xml extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__img_icons_control_090_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_control_180_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_control_270_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_control_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_exclamation__frame_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_exclamation_red_frame_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_exclamation_red_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_exclamation_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_information_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_lightning_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_script_code_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_ui_buttons_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_ui_progress_bar_indeterminate_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_ui_progress_bar_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_user_nude_female_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_icons_user_nude_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_loaded_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_logo_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_logos_oxford01_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_logos_oxford02_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__img_openfl_svg extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__img_square_ttf extends flash.text.Font { }
@:keep @:bind #if display private #end class __ASSET__ui_custom_number_stepper_xml extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__ui_debug_window_xml extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__data_countries_json extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_down_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_down_arrow_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_gripper_horizontal_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_gripper_vertical_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_left_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_left_arrow_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_right_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_right_arrow_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_up_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_up_arrow_white_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_up_down_arrows_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_xpt_css extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__themes_xpt_xpt_min_css extends flash.utils.ByteArray { }


#elseif html5






































































@:keep #if display private #end class __ASSET__fonts_oxygen_bold_ttf extends lime.text.Font { public function new () { super (); name = "Oxygen Bold"; } } 




@:keep #if display private #end class __ASSET__fonts_oxygen_ttf extends lime.text.Font { public function new () { super (); name = "Oxygen Regular"; } } 



@:keep #if display private #end class __ASSET__assets_fonts_oxygen_bold_ttf extends lime.text.Font { public function new () { super (); name = "Oxygen Bold"; } } 

@:keep #if display private #end class __ASSET__assets_fonts_oxygen_ttf extends lime.text.Font { public function new () { super (); name = "Oxygen Regular"; } } 























@:keep #if display private #end class __ASSET__assets_img_square_ttf extends lime.text.Font { public function new () { super (); name = "SquareFont"; } } 





































@:keep #if display private #end class __ASSET__img_square_ttf extends lime.text.Font { public function new () { super (); name = "SquareFont"; } } 


















#else



#if (windows || mac || linux || cpp)


@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/default/circle.png") #if display private #end class __ASSET__styles_default_circle_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/default/collapse.png") #if display private #end class __ASSET__styles_default_collapse_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/default/cross.png") #if display private #end class __ASSET__styles_default_cross_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/default/expand.png") #if display private #end class __ASSET__styles_default_expand_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/default/up_down.png") #if display private #end class __ASSET__styles_default_up_down_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/arrow_down.png") #if display private #end class __ASSET__styles_gradient_arrow_down_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/arrow_down_dark.png") #if display private #end class __ASSET__styles_gradient_arrow_down_dark_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/arrow_down_disabled.png") #if display private #end class __ASSET__styles_gradient_arrow_down_disabled_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/arrow_left.png") #if display private #end class __ASSET__styles_gradient_arrow_left_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/arrow_left_disabled.png") #if display private #end class __ASSET__styles_gradient_arrow_left_disabled_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/arrow_right.png") #if display private #end class __ASSET__styles_gradient_arrow_right_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/arrow_right2.png") #if display private #end class __ASSET__styles_gradient_arrow_right2_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/arrow_right_dark.png") #if display private #end class __ASSET__styles_gradient_arrow_right_dark_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/arrow_right_disabled.png") #if display private #end class __ASSET__styles_gradient_arrow_right_disabled_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/arrow_up.png") #if display private #end class __ASSET__styles_gradient_arrow_up_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/arrow_up_disabled.png") #if display private #end class __ASSET__styles_gradient_arrow_up_disabled_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/circle_dark.png") #if display private #end class __ASSET__styles_gradient_circle_dark_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/cross_dark.png") #if display private #end class __ASSET__styles_gradient_cross_dark_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/cross_dark_disabled.png") #if display private #end class __ASSET__styles_gradient_cross_dark_disabled_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/cross_light_small.png") #if display private #end class __ASSET__styles_gradient_cross_light_small_png extends lime.graphics.Image {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/gradient.css") #if display private #end class __ASSET__styles_gradient_gradient_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/gradient.min.css") #if display private #end class __ASSET__styles_gradient_gradient_min_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/gradient_mobile.css") #if display private #end class __ASSET__styles_gradient_gradient_mobile_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/gradient_mobile.min.css") #if display private #end class __ASSET__styles_gradient_gradient_mobile_min_css extends lime.utils.Bytes {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/gripper_horizontal.png") #if display private #end class __ASSET__styles_gradient_gripper_horizontal_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/gripper_horizontal_disabled.png") #if display private #end class __ASSET__styles_gradient_gripper_horizontal_disabled_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/gripper_vertical.png") #if display private #end class __ASSET__styles_gradient_gripper_vertical_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/gripper_vertical_disabled.png") #if display private #end class __ASSET__styles_gradient_gripper_vertical_disabled_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/hsplitter_gripper.png") #if display private #end class __ASSET__styles_gradient_hsplitter_gripper_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/gradient/vsplitter_gripper.png") #if display private #end class __ASSET__styles_gradient_vsplitter_gripper_png extends lime.graphics.Image {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/accordion.css") #if display private #end class __ASSET__styles_windows_accordion_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/accordion.min.css") #if display private #end class __ASSET__styles_windows_accordion_min_css extends lime.utils.Bytes {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/button.png") #if display private #end class __ASSET__styles_windows_button_png extends lime.graphics.Image {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/buttons.css") #if display private #end class __ASSET__styles_windows_buttons_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/buttons.min.css") #if display private #end class __ASSET__styles_windows_buttons_min_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/calendar.css") #if display private #end class __ASSET__styles_windows_calendar_css extends lime.utils.Bytes {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/checkbox.png") #if display private #end class __ASSET__styles_windows_checkbox_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/container.png") #if display private #end class __ASSET__styles_windows_container_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/glyphs/down_arrow.png") #if display private #end class __ASSET__styles_windows_glyphs_down_arrow_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/glyphs/hscroll_thumb_gripper_down.png") #if display private #end class __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_down_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/glyphs/hscroll_thumb_gripper_over.png") #if display private #end class __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_over_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/glyphs/hscroll_thumb_gripper_up.png") #if display private #end class __ASSET__styles_windows_glyphs_hscroll_thumb_gripper_up_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/glyphs/left_arrow.png") #if display private #end class __ASSET__styles_windows_glyphs_left_arrow_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/glyphs/right_arrow.png") #if display private #end class __ASSET__styles_windows_glyphs_right_arrow_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/glyphs/up_arrow.png") #if display private #end class __ASSET__styles_windows_glyphs_up_arrow_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/glyphs/vscroll_thumb_gripper_down.png") #if display private #end class __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_down_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/glyphs/vscroll_thumb_gripper_over.png") #if display private #end class __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_over_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/glyphs/vscroll_thumb_gripper_up.png") #if display private #end class __ASSET__styles_windows_glyphs_vscroll_thumb_gripper_up_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/hprogress.png") #if display private #end class __ASSET__styles_windows_hprogress_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/hscroll.png") #if display private #end class __ASSET__styles_windows_hscroll_png extends lime.graphics.Image {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/listview.css") #if display private #end class __ASSET__styles_windows_listview_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/listview.min.css") #if display private #end class __ASSET__styles_windows_listview_min_css extends lime.utils.Bytes {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/listview.png") #if display private #end class __ASSET__styles_windows_listview_png extends lime.graphics.Image {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/menus.css") #if display private #end class __ASSET__styles_windows_menus_css extends lime.utils.Bytes {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/optionbox.png") #if display private #end class __ASSET__styles_windows_optionbox_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/popup.png") #if display private #end class __ASSET__styles_windows_popup_png extends lime.graphics.Image {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/popups.css") #if display private #end class __ASSET__styles_windows_popups_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/rtf.css") #if display private #end class __ASSET__styles_windows_rtf_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/scrolls.css") #if display private #end class __ASSET__styles_windows_scrolls_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/scrolls.min.css") #if display private #end class __ASSET__styles_windows_scrolls_min_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/sliders.css") #if display private #end class __ASSET__styles_windows_sliders_css extends lime.utils.Bytes {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/tab.png") #if display private #end class __ASSET__styles_windows_tab_png extends lime.graphics.Image {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/tabs.css") #if display private #end class __ASSET__styles_windows_tabs_css extends lime.utils.Bytes {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/textinput.png") #if display private #end class __ASSET__styles_windows_textinput_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/vprogress.png") #if display private #end class __ASSET__styles_windows_vprogress_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/vscroll.png") #if display private #end class __ASSET__styles_windows_vscroll_png extends lime.graphics.Image {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/styles/windows/windows.css") #if display private #end class __ASSET__styles_windows_windows_css extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/fonts/Oxygen-Bold.eot") #if display private #end class __ASSET__fonts_oxygen_bold_eot extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/fonts/Oxygen-Bold.svg") #if display private #end class __ASSET__fonts_oxygen_bold_svg extends lime.utils.Bytes {}
@:font("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/fonts/Oxygen-Bold.ttf") #if display private #end class __ASSET__fonts_oxygen_bold_ttf extends lime.text.Font {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/fonts/Oxygen-Bold.woff") #if display private #end class __ASSET__fonts_oxygen_bold_woff extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/fonts/Oxygen-Bold.woff2") #if display private #end class __ASSET__fonts_oxygen_bold_woff2 extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/fonts/Oxygen.eot") #if display private #end class __ASSET__fonts_oxygen_eot extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/fonts/Oxygen.svg") #if display private #end class __ASSET__fonts_oxygen_svg extends lime.utils.Bytes {}
@:font("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/fonts/Oxygen.ttf") #if display private #end class __ASSET__fonts_oxygen_ttf extends lime.text.Font {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/fonts/Oxygen.woff") #if display private #end class __ASSET__fonts_oxygen_woff extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/haxeui/1,8,16/assets/fonts/Oxygen.woff2") #if display private #end class __ASSET__fonts_oxygen_woff2 extends lime.utils.Bytes {}
@:file("assets/data/countries.json") #if display private #end class __ASSET__assets_data_countries_json extends lime.utils.Bytes {}
@:font("assets/fonts/Oxygen-Bold.ttf") #if display private #end class __ASSET__assets_fonts_oxygen_bold_ttf extends lime.text.Font {}
@:file("assets/fonts/Oxygen-Bold.woff") #if display private #end class __ASSET__assets_fonts_oxygen_bold_woff extends lime.utils.Bytes {}
@:font("assets/fonts/Oxygen.ttf") #if display private #end class __ASSET__assets_fonts_oxygen_ttf extends lime.text.Font {}
@:file("assets/fonts/Oxygen.woff") #if display private #end class __ASSET__assets_fonts_oxygen_woff extends lime.utils.Bytes {}
@:file("assets/html5/index.html") #if display private #end class __ASSET__assets_html5_index_html extends lime.utils.Bytes {}
@:image("assets/img/icons/control-090.png") #if display private #end class __ASSET__assets_img_icons_control_090_png extends lime.graphics.Image {}
@:image("assets/img/icons/control-180.png") #if display private #end class __ASSET__assets_img_icons_control_180_png extends lime.graphics.Image {}
@:image("assets/img/icons/control-270.png") #if display private #end class __ASSET__assets_img_icons_control_270_png extends lime.graphics.Image {}
@:image("assets/img/icons/control.png") #if display private #end class __ASSET__assets_img_icons_control_png extends lime.graphics.Image {}
@:image("assets/img/icons/exclamation--frame.png") #if display private #end class __ASSET__assets_img_icons_exclamation__frame_png extends lime.graphics.Image {}
@:image("assets/img/icons/exclamation-red-frame.png") #if display private #end class __ASSET__assets_img_icons_exclamation_red_frame_png extends lime.graphics.Image {}
@:image("assets/img/icons/exclamation-red.png") #if display private #end class __ASSET__assets_img_icons_exclamation_red_png extends lime.graphics.Image {}
@:image("assets/img/icons/exclamation.png") #if display private #end class __ASSET__assets_img_icons_exclamation_png extends lime.graphics.Image {}
@:image("assets/img/icons/information-white.png") #if display private #end class __ASSET__assets_img_icons_information_white_png extends lime.graphics.Image {}
@:image("assets/img/icons/lightning.png") #if display private #end class __ASSET__assets_img_icons_lightning_png extends lime.graphics.Image {}
@:image("assets/img/icons/script-code.png") #if display private #end class __ASSET__assets_img_icons_script_code_png extends lime.graphics.Image {}
@:image("assets/img/icons/ui-buttons.png") #if display private #end class __ASSET__assets_img_icons_ui_buttons_png extends lime.graphics.Image {}
@:image("assets/img/icons/ui-progress-bar-indeterminate.png") #if display private #end class __ASSET__assets_img_icons_ui_progress_bar_indeterminate_png extends lime.graphics.Image {}
@:image("assets/img/icons/ui-progress-bar.png") #if display private #end class __ASSET__assets_img_icons_ui_progress_bar_png extends lime.graphics.Image {}
@:image("assets/img/icons/user-nude-female.png") #if display private #end class __ASSET__assets_img_icons_user_nude_female_png extends lime.graphics.Image {}
@:image("assets/img/icons/user-nude.png") #if display private #end class __ASSET__assets_img_icons_user_nude_png extends lime.graphics.Image {}
@:image("assets/img/loaded.png") #if display private #end class __ASSET__assets_img_loaded_png extends lime.graphics.Image {}
@:image("assets/img/logo.png") #if display private #end class __ASSET__assets_img_logo_png extends lime.graphics.Image {}
@:image("assets/img/logos/oxford01.png") #if display private #end class __ASSET__assets_img_logos_oxford01_png extends lime.graphics.Image {}
@:image("assets/img/logos/oxford02.png") #if display private #end class __ASSET__assets_img_logos_oxford02_png extends lime.graphics.Image {}
@:file("assets/img/openfl.svg") #if display private #end class __ASSET__assets_img_openfl_svg extends lime.utils.Bytes {}
@:font("assets/img/square.ttf") #if display private #end class __ASSET__assets_img_square_ttf extends lime.text.Font {}
@:file("assets/openfl.svg") #if display private #end class __ASSET__assets_openfl_svg extends lime.utils.Bytes {}
@:image("assets/themes/xpt/down_arrow.png") #if display private #end class __ASSET__assets_themes_xpt_down_arrow_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/down_arrow_white.png") #if display private #end class __ASSET__assets_themes_xpt_down_arrow_white_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/gripper_horizontal.png") #if display private #end class __ASSET__assets_themes_xpt_gripper_horizontal_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/gripper_vertical.png") #if display private #end class __ASSET__assets_themes_xpt_gripper_vertical_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/left_arrow.png") #if display private #end class __ASSET__assets_themes_xpt_left_arrow_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/left_arrow_white.png") #if display private #end class __ASSET__assets_themes_xpt_left_arrow_white_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/right_arrow.png") #if display private #end class __ASSET__assets_themes_xpt_right_arrow_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/right_arrow_white.png") #if display private #end class __ASSET__assets_themes_xpt_right_arrow_white_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/up_arrow.png") #if display private #end class __ASSET__assets_themes_xpt_up_arrow_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/up_arrow_white.png") #if display private #end class __ASSET__assets_themes_xpt_up_arrow_white_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/up_down_arrows.png") #if display private #end class __ASSET__assets_themes_xpt_up_down_arrows_png extends lime.graphics.Image {}
@:file("assets/themes/xpt/xpt.css") #if display private #end class __ASSET__assets_themes_xpt_xpt_css extends lime.utils.Bytes {}
@:file("assets/themes/xpt/xpt.min.css") #if display private #end class __ASSET__assets_themes_xpt_xpt_min_css extends lime.utils.Bytes {}
@:file("assets/ui/custom/number-stepper.xml") #if display private #end class __ASSET__assets_ui_custom_number_stepper_xml extends lime.utils.Bytes {}
@:file("assets/ui/debug-window.xml") #if display private #end class __ASSET__assets_ui_debug_window_xml extends lime.utils.Bytes {}
@:image("assets/img/icons/control-090.png") #if display private #end class __ASSET__img_icons_control_090_png extends lime.graphics.Image {}
@:image("assets/img/icons/control-180.png") #if display private #end class __ASSET__img_icons_control_180_png extends lime.graphics.Image {}
@:image("assets/img/icons/control-270.png") #if display private #end class __ASSET__img_icons_control_270_png extends lime.graphics.Image {}
@:image("assets/img/icons/control.png") #if display private #end class __ASSET__img_icons_control_png extends lime.graphics.Image {}
@:image("assets/img/icons/exclamation--frame.png") #if display private #end class __ASSET__img_icons_exclamation__frame_png extends lime.graphics.Image {}
@:image("assets/img/icons/exclamation-red-frame.png") #if display private #end class __ASSET__img_icons_exclamation_red_frame_png extends lime.graphics.Image {}
@:image("assets/img/icons/exclamation-red.png") #if display private #end class __ASSET__img_icons_exclamation_red_png extends lime.graphics.Image {}
@:image("assets/img/icons/exclamation.png") #if display private #end class __ASSET__img_icons_exclamation_png extends lime.graphics.Image {}
@:image("assets/img/icons/information-white.png") #if display private #end class __ASSET__img_icons_information_white_png extends lime.graphics.Image {}
@:image("assets/img/icons/lightning.png") #if display private #end class __ASSET__img_icons_lightning_png extends lime.graphics.Image {}
@:image("assets/img/icons/script-code.png") #if display private #end class __ASSET__img_icons_script_code_png extends lime.graphics.Image {}
@:image("assets/img/icons/ui-buttons.png") #if display private #end class __ASSET__img_icons_ui_buttons_png extends lime.graphics.Image {}
@:image("assets/img/icons/ui-progress-bar-indeterminate.png") #if display private #end class __ASSET__img_icons_ui_progress_bar_indeterminate_png extends lime.graphics.Image {}
@:image("assets/img/icons/ui-progress-bar.png") #if display private #end class __ASSET__img_icons_ui_progress_bar_png extends lime.graphics.Image {}
@:image("assets/img/icons/user-nude-female.png") #if display private #end class __ASSET__img_icons_user_nude_female_png extends lime.graphics.Image {}
@:image("assets/img/icons/user-nude.png") #if display private #end class __ASSET__img_icons_user_nude_png extends lime.graphics.Image {}
@:image("assets/img/loaded.png") #if display private #end class __ASSET__img_loaded_png extends lime.graphics.Image {}
@:image("assets/img/logo.png") #if display private #end class __ASSET__img_logo_png extends lime.graphics.Image {}
@:image("assets/img/logos/oxford01.png") #if display private #end class __ASSET__img_logos_oxford01_png extends lime.graphics.Image {}
@:image("assets/img/logos/oxford02.png") #if display private #end class __ASSET__img_logos_oxford02_png extends lime.graphics.Image {}
@:file("assets/img/openfl.svg") #if display private #end class __ASSET__img_openfl_svg extends lime.utils.Bytes {}
@:font("assets/img/square.ttf") #if display private #end class __ASSET__img_square_ttf extends lime.text.Font {}
@:file("assets/ui/custom/number-stepper.xml") #if display private #end class __ASSET__ui_custom_number_stepper_xml extends lime.utils.Bytes {}
@:file("assets/ui/debug-window.xml") #if display private #end class __ASSET__ui_debug_window_xml extends lime.utils.Bytes {}
@:file("assets/data/countries.json") #if display private #end class __ASSET__data_countries_json extends lime.utils.Bytes {}
@:image("assets/themes/xpt/down_arrow.png") #if display private #end class __ASSET__themes_xpt_down_arrow_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/down_arrow_white.png") #if display private #end class __ASSET__themes_xpt_down_arrow_white_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/gripper_horizontal.png") #if display private #end class __ASSET__themes_xpt_gripper_horizontal_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/gripper_vertical.png") #if display private #end class __ASSET__themes_xpt_gripper_vertical_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/left_arrow.png") #if display private #end class __ASSET__themes_xpt_left_arrow_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/left_arrow_white.png") #if display private #end class __ASSET__themes_xpt_left_arrow_white_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/right_arrow.png") #if display private #end class __ASSET__themes_xpt_right_arrow_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/right_arrow_white.png") #if display private #end class __ASSET__themes_xpt_right_arrow_white_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/up_arrow.png") #if display private #end class __ASSET__themes_xpt_up_arrow_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/up_arrow_white.png") #if display private #end class __ASSET__themes_xpt_up_arrow_white_png extends lime.graphics.Image {}
@:image("assets/themes/xpt/up_down_arrows.png") #if display private #end class __ASSET__themes_xpt_up_down_arrows_png extends lime.graphics.Image {}
@:file("assets/themes/xpt/xpt.css") #if display private #end class __ASSET__themes_xpt_xpt_css extends lime.utils.Bytes {}
@:file("assets/themes/xpt/xpt.min.css") #if display private #end class __ASSET__themes_xpt_xpt_min_css extends lime.utils.Bytes {}



#end
#end

#if (openfl && !flash)
@:keep #if display private #end class __ASSET__OPENFL__fonts_oxygen_bold_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__fonts_oxygen_bold_ttf (); src = font.src; name = font.name; super (); }}
@:keep #if display private #end class __ASSET__OPENFL__fonts_oxygen_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__fonts_oxygen_ttf (); src = font.src; name = font.name; super (); }}
@:keep #if display private #end class __ASSET__OPENFL__assets_fonts_oxygen_bold_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__assets_fonts_oxygen_bold_ttf (); src = font.src; name = font.name; super (); }}
@:keep #if display private #end class __ASSET__OPENFL__assets_fonts_oxygen_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__assets_fonts_oxygen_ttf (); src = font.src; name = font.name; super (); }}
@:keep #if display private #end class __ASSET__OPENFL__assets_img_square_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__assets_img_square_ttf (); src = font.src; name = font.name; super (); }}
@:keep #if display private #end class __ASSET__OPENFL__img_square_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__img_square_ttf (); src = font.src; name = font.name; super (); }}

#end

#end