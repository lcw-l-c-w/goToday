package kr.co.gotoday.vendor;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.content.ContentVo;

@Service
public class VendorServiceImpl implements VendorService {
	
	@Autowired
	private VendorMapper vendorMapper;
	
	@Override
	public int contentCreate(ContentVo contentVo, MultipartFile file, HttpServletRequest request) {
		if(!file.isEmpty() && file !=null) {
			//파일 명명
			String org = file.getOriginalFilename();
			String file_name = contentVo.getTitle() + org;
			
			//파일 저장
			String path = request.getRealPath("/upload/poster/") + file_name;
			try {
				file.transferTo(new File(path));
			} catch (Exception e) {	}
			contentVo.setMain_image_path(path);
		}
		int r = vendorMapper.contentCreate(contentVo);
		return r;
	}
	
	@Override
	public Map<String, Object> list(ContentVo contentVo){
		Map<String, Object> map = new HashMap<>();
		
		return map;
	}
	
	

}
