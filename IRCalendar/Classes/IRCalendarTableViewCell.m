//
//  IRCalendarTableViewCell.m
//  IRCalendar
//
//  Created by irons on 2020/9/7.
//  Copyright © 2020 irons. All rights reserved.
//

#import "IRCalendarTableViewCell.h"

@implementation IRCalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


private static final String TAG = "Cell";
protected Rect mBound = null;
protected int mDayOfMonth = 1;    // from 1 to 31
protected Paint mPaint = new Paint(Paint.SUBPIXEL_TEXT_FLAG
        |Paint.ANTI_ALIAS_FLAG);
int dx, dy;
public Cell(int dayOfMon, Rect rect, float textSize, boolean bold) {
    mDayOfMonth = dayOfMon;
    mBound = rect;
    mPaint.setTextSize(textSize/*26f*/);
    mPaint.setColor(Color.BLACK);
    if(bold) mPaint.setFakeBoldText(true);
    
    dx = (int) mPaint.measureText(String.valueOf(mDayOfMonth)) / 2;
    dy = (int) (-mPaint.ascent() + mPaint.descent()) / 2;
}

public Cell(int dayOfMon, Rect rect, float textSize) {
    this(dayOfMon, rect, textSize, false);
}

protected void draw(Canvas canvas) {
    canvas.drawText(String.valueOf(mDayOfMonth), mBound.centerX() - dx, mBound.centerY() + dy, mPaint);
}

public int getDayOfMonth() {
    return mDayOfMonth;
}

public boolean hitTest(int x, int y) {
    return mBound.contains(x, y);
}

public Rect getBound() {
    return mBound;
}

public String toString() {
    return String.valueOf(mDayOfMonth)+"("+mBound.toString()+")";
}