//
//  IRCalendarViewController.m
//  IRCalendar
//
//  Created by irons on 2020/9/7.
//  Copyright © 2020 irons. All rights reserved.
//

#import "IRCalendarViewController.h"

@interface IRCalendarViewController ()

@end

@implementation IRCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


public static final String MIME_TYPE = "vnd.android.cursor.dir/vnd.exina.android.calendar.date";
CalendarView mView = null;
TextView mHit;
Handler mHandler = new Handler();

Button setBtn;
ImageButton beforeBtn, nextBtn;
TextView dateText;
int year;
int month;
myResetReceiver receiver;
mmyResetReceiver receiver2;
public static int mcDay,mcYear,mcMonth;
/** Called when the activity is first created. */
@Override
public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.calender_main);
    
    SharedPreferences preferences = getSharedPreferences("clickDate", 0);
    int bg =preferences.getInt("background", 0);
    if(bg==0){
        View layout = (View)findViewById(R.id.layout1);
        layout.setBackgroundDrawable(getResources().getDrawable(R.drawable.dot_blue));
        SharedPreferences preferences3 = getSharedPreferences("clickDate", 0);
        SharedPreferences.Editor editor = preferences3.edit();
        editor.putInt("background", R.drawable.dot_blue);
        editor.commit();
        }
    if(bg!=0){
    View layout = (View)findViewById(R.id.layout1);
    layout.setBackgroundDrawable(getResources().getDrawable(bg));
    }
    
    SharedPreferences preferences2 = getSharedPreferences("clickDate", 0);
    mcDay =preferences2.getInt("mcDay", 0);
    mcMonth =preferences2.getInt("mcMonth", 0);
    mcYear =preferences2.getInt("mcYear", 0);
    
    mView = (CalendarView)findViewById(R.id.calendar);
    mView.setOnCellTouchListener(this);
    
    //if(getIntent().getAction().equals(Intent.ACTION_PICK))
        //findViewById(R.id.hint).setVisibility(View.INVISIBLE);
    
    setBtn =(Button)findViewById(R.id.setbutton1);
    setBtn.setOnClickListener(new OnClickListener() {
        
        @Override
        public void onClick(View v) {
            // TODO Auto-generated method stub
            Intent intent = new Intent(CalendarActivity.this, SetMenu.class);
            startActivity(intent);
        }
    });
    
    dateText=(TextView)findViewById(R.id.dateText);
    year  = mView.getYear();
    month = mView.getMonth()+1;
    dateText.setText(year+"年"+month+"月");
    
    beforeBtn=(ImageButton)findViewById(R.id.calenderImageButton01);
    nextBtn=(ImageButton)findViewById(R.id.calenderImageButton02);
    
    beforeBtn.setOnClickListener(new OnClickListener() {
        
        @Override
        public void onClick(View v) {
            mView.previousMonth();
            year  = mView.getYear();
            month = mView.getMonth()+1;
            dateText.setText(year+"年"+month+"月");
        }
    });
    
    nextBtn.setOnClickListener(new OnClickListener() {
        
        @Override
        public void onClick(View v) {
            mView.nextMonth();
            year  = mView.getYear();
            month = mView.getMonth()+1;
            dateText.setText(year+"年"+month+"月");
        }
    });
    
    IntentFilter filter = new IntentFilter("tw.com.irons.try_case2.BG");
    receiver = new myResetReceiver();
    registerReceiver(receiver, filter);
    
    IntentFilter filter2 = new IntentFilter("tw.com.irons.try_case2.MC");
    receiver2 = new mmyResetReceiver();
    registerReceiver(receiver2, filter2);
}

private class myResetReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {

            Log.e("calendarBroadcast", "BG");
        SharedPreferences preferences = getSharedPreferences("clickDate", 0);
        int bg =preferences.getInt("background", 0);
        View layout = (View)findViewById(R.id.layout1);
        layout.setBackgroundDrawable(getResources().getDrawable(bg));
    
        
    }
}

private class mmyResetReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
    
            Log.e("calendarBroadcast", "MC");
            mView = (CalendarView)findViewById(R.id.calendar);
        
    }
}

public void onTouch(Cell cell) {
    Intent intent = getIntent();
    String action = intent.getAction();

        year  = mView.getYear();
        month = mView.getMonth();
        int day   = cell.getDayOfMonth();
        
        // FIX issue 6: make some correction on month and year
        if(cell instanceof CalendarView.GrayCell) {
            // oops, not pick current month...
            if (day < 15) {
                // pick one beginning day? then a next month day
                if(month==11)
                {
                    month = 0;
                    year++;
                } else {
                    month++;
                }
                
            } else {
                // otherwise, previous month
                if(month==0) {
                    month = 11;
                    year--;
                } else {
                    month--;
                }
            }
        }
        
        
        month=month+1;
        //MyApplication application = (MyApplication)this.getApplicationContext();
        //MyApplication.clickDate = DateUtil2.getdate(year+"", month+"", day+"", 100);
        String clickDate = DateUtil2.getdate(year+"", month+"", day+"", 100);
        SharedPreferences preferences = getSharedPreferences("clickDate", 0);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putString("clickDate", clickDate);
        editor.commit();
        
        Toast.makeText(CalendarActivity.this, clickDate , Toast.LENGTH_SHORT).show();
        
        //Intent msgIntent = getIntent();
        TranObject msg = (TranObject) getIntent().getSerializableExtra(Constants.MSGKEY);
        
        Intent intent2 = new Intent(CalendarActivity.this, MainMenu.class);
        intent2.putExtra(Constants.MSGKEY, msg);
        startActivity(intent2);
        
        


    mHandler.post(new Runnable() {
        public void run() {
            Toast.makeText(CalendarActivity.this, DateUtils.getMonthString(mView.getMonth(), DateUtils.LENGTH_LONG) + " "+mView.getYear(), Toast.LENGTH_SHORT).show();
        }
    });
    
    //finish();
    return;
    
    
}

@Override
public void onBackPressed() {
    // TODO Auto-generated method stub
    //super.onBackPressed();
    

    
    exitDialog(CalendarActivity.this, "登出", "確定要登出嗎？");
    
    //finish();
}

// 完全退出提示窗
private void exitDialog(Context context, String title, String msg) {
    final MyApplication application = (MyApplication) this.getApplicationContext();
    
    new AlertDialog.Builder(context).setTitle(title).setMessage(msg)
            .setPositiveButton("確定", new DialogInterface.OnClickListener() {

                @Override
                public void onClick(DialogInterface dialog, int which) {
                    // 關閉服務
                    if (application.isClientStart()) {
                        Intent service = new Intent(
                                CalendarActivity.this,
                                GetMsgService.class);
                        stopService(service);
                    }
                    
                    unregisterReceiver(receiver);
                    unregisterReceiver(receiver2);
                    
                    Intent i = new Intent();
                    i.setAction(Constants.ACTION);
                    sendBroadcast(i);
                    finish();
                }
            }).setNegativeButton("取消", null).create().show();
}
