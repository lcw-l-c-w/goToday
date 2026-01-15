package kr.co.gotoday.content;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PopupController {
	
	@Autowired
	private ContentService contentService;
	
	@GetMapping("/main/popup")
	public String popup(Model model) {
		
		
		
		model.addAttribute("popularList", contentService.getPopularContent(7,"popup")); 
		model.addAttribute("upcomingList", contentService.getUpcomingContent(10,"popup")); 
		
		return "main/popup";
	}
}
