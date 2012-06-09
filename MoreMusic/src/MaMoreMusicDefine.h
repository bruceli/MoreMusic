#define kOAuthConsumerKey				@"1311591556"
#define kOAuthConsumerSecret			@"3678355a4d9a353102ecf755a9265a61"

typedef enum {
    MaSendMessageType_Post = 1,
    MaSendMessageType_RePost ,
    MaSendMessageType_Comment,
}MaSendMessageType;

typedef enum {
    MaMessageType_TimeLine  = 1,
    MaMessageType_Mention  ,
    MaMessageType_Comment  ,
    MaMessageType_Repost ,
} MaMessageType;


typedef enum{
    MaFirstDay = 0,
    MaSecondDay,
} MaActivityDay;


typedef enum{
    MaReplayButton = 0,
    MaRePostButton,
    MaFavoriteButton,
} MaCellButtonType;

#define FIRST_DAY_STRING    @"2012-6-22"
#define SECOND_DAY_STRING   @"2012-6-23"

#define PICT_SIDE 48
#define MAX_TEXT_LENGTH 140
#define IMAGE_SIDE 48
#define BORDER_WIDTH 5
#define TEXT_OFFSET_X (BORDER_WIDTH * 2 + IMAGE_SIDE)
#define LABEL_HEIGHT 20
#define NEW_LABEL_HEIGHT 15
#define LABEL_WIDTH 120
#define TEXT_WIDTH (320 - TEXT_OFFSET_X - BORDER_WIDTH)
#define TEXT_OFFSET_Y (BORDER_WIDTH * 2 + LABEL_HEIGHT)
#define TEXT_HEIGHT (ROW_HEIGHT - TEXT_OFFSET_Y - BORDER_WIDTH)
#define COMMENTVIEW_BORDER 30
#define CELLWITHCOMMENTVIEW_BORDER 35
#define ROW_HEIGHT (IMAGE_SIDE + BORDER_WIDTH * 2)

#define BOUNCE_PIXELS 5.0
#define BUTTON_LEFT_MARGIN 10.0
#define BUTTON_SPACING 25.0
#define PUSH_STYLE_ANIMATION NO
#define SWIPE_BAR_HEIGHT 50
#define USE_GESTURE_RECOGNIZERS YES


#define OUTPUT_IMAGE_WIDE_MAX 320
#define OUTPUT_LANDSCAPE_IMAGE_WIDE_MAX 1024
#define OUTPUT_PORTRAIT_IMAGE_WIDE_MAX 768

#define JSON_STAT_HOME_TIMELINE @"statuses/home_timeline.json"
#define JSON_STAT_MENTIONS @"statuses/mentions.json"
#define JSON_COMMENT_TOME @"comments/to_me.json"
#define JSON_REPOST_TIMELINE @"statuses/repost_timeline"
