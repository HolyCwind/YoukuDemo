## DESCRIPTION
通过给定的优酷空间网址，得到视频列表

## FEATURES
* 可以得到视频的标题、缩略图
* 通过指定清晰度类型（超清、高清、标清），得到对应的m3u8文件地址

## USAGE
```
# import "YoukuHelp.h"

YoukeHelp *myYouku = [YoukuHelp initWithUrl:[NSURL URLWithString:myURL]];                  //根据指定的url初始化

[myYouku getTitle:indexPath.row]                                                          //得到视频标题
[myYouku getThumbnail:indexPath.row]                                                      //得到视频缩略图
[myYouku getVideoUrl:indexPath.row withType:VIDEOTYPE]                                    //得到对应的m3u8文件地址
```
## NOTE
 
解析HTML用了[Hpple](https://github.com/topfunky/hpple)

优酷全站的HTML代码并不规范，各个空间的格式不尽相同（目前已经发现三个版本），所以特定情况下需要根据网页源代码修改

