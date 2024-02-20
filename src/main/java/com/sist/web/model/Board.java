package com.sist.web.model;

import java.io.Serializable;

public class Board implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private long bdSeq;
	private String bdTitle;
	private String bdContent;
	private String udId;
	private String udNickname;
	private long bdReadCnt;
	private String bdRegDate;
	private String bdModDate;
	private String bdSecret;
	private long bdLikeCnt;
	
	private String bdSort;
	
	//ROWNUM 에 쓸 START, END번호 
	private long startRow;
	private long endRow;
	
	public Board()
	{
		bdSeq = 0;
		bdTitle = "";
		bdContent = "";
		udId = "";
		udNickname = "";
		bdReadCnt = 0;
		bdRegDate = "";
		bdModDate = "";
		bdSecret = "N";
		bdLikeCnt = 0;
		
		bdSort = "1";
		
		startRow = 0;
		endRow = 0;
	}
	
	public long getBdSeq() 
	{
		return bdSeq;
	}
	public void setBdSeq(long bdSeq) 
	{
		this.bdSeq = bdSeq;
	}
	public String getBdTitle() 
	{
		return bdTitle;
	}
	public void setBdTitle(String bdTitle) 
	{
		this.bdTitle = bdTitle;
	}
	public String getBdContent() 
	{
		return bdContent;
	}
	public void setBdContent(String bdContent) 
	{
		this.bdContent = bdContent;
	}
	public String getUdId() 
	{
		return udId;
	}
	public void setUdId(String udId)
	{
		this.udId = udId;
	}
	
	public String getUdNickname() 
	{
		return udNickname;
	}
	public void setUdNickname(String udNickname) 
	{
		this.udNickname = udNickname;
	}
	public long getBdReadCnt()
	{
		return bdReadCnt;
	}
	public void setBdReadCnt(long bdReadCnt)
	{
		this.bdReadCnt = bdReadCnt;
	}
	public String getBdRegDate()
	{
		return bdRegDate;
	}
	public void setBdRegDate(String bdRegDate) 
	{
		this.bdRegDate = bdRegDate;
	}
	public String getBdModDate() 
	{
		return bdModDate;
	}
	public void setBdModDate(String bdModDate) 
	{
		this.bdModDate = bdModDate;
	}
	public String getBdSecret() 
	{
		return bdSecret;
	}
	public void setBdSecret(String bdSecret) 
	{
		this.bdSecret = bdSecret;
	}
	public long getBdLikeCnt() 
	{
		return bdLikeCnt;
	}
	public void setBdLikeCnt(long bdLikeCnt) 
	{
		this.bdLikeCnt = bdLikeCnt;
	}
	
	public String getBdSort() 
	{
		return bdSort;
	}

	public void setBdSort(String bdSort) 
	{
		this.bdSort = bdSort;
	}

	public long getStartRow()
	{
		return startRow;
	}
	public void setStartRow(long startRow) 
	{
		this.startRow = startRow;
	}
	public long getEndRow() 
	{
		return endRow;
	}
	public void setEndRow(long endRow) 
	{
		this.endRow = endRow;
	}
}