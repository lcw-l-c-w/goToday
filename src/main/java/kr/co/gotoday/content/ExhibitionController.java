package kr.co.gotoday.content;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ExhibitionController {

	@Autowired
	private ContentService contentService;
	@GetMapping("/main/exhibition")
	public String exhibition(Model model) {
		
		model.addAttribute("popupList", contentService.getPopularContent(7, "exhibition"));
		model.addAttribute("upcomingList", contentService.getUpcomingContent(10, "exhibition"));
		
		return "main/exhibition";
	}
}
