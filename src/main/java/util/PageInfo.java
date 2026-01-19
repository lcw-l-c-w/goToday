package util;

import lombok.Data;

@Data
public class PageInfo {
    private int count;
    private int totalPage;
    private int page;
    private int startPage;
    private int endPage;
    private boolean prev;
    private boolean next;

    public static PageInfo of(int count, Integer pageParam, int pageSize, int blockSize) {
        int page = (pageParam == null || pageParam < 1) ? 1 : pageParam;

        int totalPage = count / pageSize;
        if (count % pageSize > 0) totalPage++;

        int endPage = (int)(Math.ceil(page / (double)blockSize) * blockSize);
        int startPage = endPage - (blockSize - 1);
        if (endPage > totalPage) endPage = totalPage;

        PageInfo p = new PageInfo();
        p.setCount(count);
        p.setTotalPage(totalPage);
        p.setPage(page);
        p.setStartPage(startPage);
        p.setEndPage(endPage);
        p.setPrev(startPage > 1);
        p.setNext(endPage < totalPage);
        return p;
    }

    public static int offset(Integer pageParam, int pageSize) {
        int page = (pageParam == null || pageParam < 1) ? 1 : pageParam;
        return (page - 1) * pageSize;
    }
}