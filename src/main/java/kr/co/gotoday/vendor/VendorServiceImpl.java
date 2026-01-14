package kr.co.gotoday.vendor;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.content.ContentVO;

@Service
public class VendorServiceImpl implements VendorService {
	
	@Autowired
	private VendorMapper vendorMapper;
	
	@Override
	public int createContent(ContentVO contentVo, MultipartFile file, HttpServletRequest request) {
		if(file !=null  && !file.isEmpty()) {
			//파일 명명
			String uploadDir = request.getServletContext().getRealPath("/upload/poster");
			String org = file.getOriginalFilename();
			String filename = contentVo.getTitle()+ "_" + org;
			
			File dir = new File(uploadDir);

			//파일 저장
			try {
				file.transferTo(new File(uploadDir, filename));
				contentVo.setMain_image_path("/upload/poster/" + filename);
			} catch (Exception e) {
				e.printStackTrace();
				return 0;
			}
		}
		return vendorMapper.createContent(contentVo);
	}
	
	@Override
	public Map<String, Object> list(ContentVO contentVo){
		Map<String, Object> map = new HashMap<>();
		
		return map;
	}
	
	

}
