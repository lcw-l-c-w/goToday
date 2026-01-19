package kr.co.gotoday.content;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SearchController {
	
	@Autowired
	private ContentService contentService;
	
	@GetMapping("/search")
	public String search(Model model, ContentSearchDTO dto) {
	    model.addAttribute("searchList", contentService.getSearchList(dto));
	    model.addAttribute("pageInfo", contentService.getSearchPageInfo(dto));
	    model.addAttribute("search", dto);
	    return "main/search";
	}
}
