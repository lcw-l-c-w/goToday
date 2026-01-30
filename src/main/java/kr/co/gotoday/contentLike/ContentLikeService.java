package kr.co.gotoday.contentLike;


public interface ContentLikeService {
	public ContentLikeVO getHeartByContentId(Integer content_id,Integer user_id);
	public int checkContentLike(Integer content_id,Integer user_id);
}
