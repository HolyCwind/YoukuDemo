## DESCRIPTION
通过给定的优酷空间网址，得到视频列表

## FEATURES
* 可以得到空间主人的ID、头像和简介
* 可以得到视频的标题、缩略图
* 通过指定清晰度类型（超清、高清、标清），得到对应的m3u8文件地址
* 支持下拉刷新
* 支持上拉加载下一页的视频列表

## USAGE
```
# import "YoukuHelp.h"

YoukuHelp *myYouku = [[YoukuHelp alloc] init];
[myYouku initWithUrl:[NSURL URLWithString:myURL]];                                        //根据指定的url初始化

[myYouku getName]                                                                         //得到空间主人的ID
[myYouku getDetails]                                                                      //得到空间主人的简介
[myYouku getImageUrl];                                                                    //得到空间主人的头像
[myYouku getTitle:indexPath.row]                                                          //得到视频标题
[myYouku getThumbnail:indexPath.row]                                                      //得到视频缩略图
[myYouku getVideoUrl:indexPath.row withType:VIDEOTYPE]                                    //得到对应的m3u8文件地址
[myYouku addList]                                                                         //添加下一页的视频列表                                
```
## NOTE
解析HTML用了[Hpple](https://github.com/topfunky/hpple)

下拉刷新和上拉加载用的是[Pull-Demo](https://github.com/HolyCwind/Pull-Demo)

优酷全站的HTML代码并不规范，各个空间的格式不尽相同（目前已经发现三个版本），所以特定情况下需要根据网页源代码修改


##SNAPSHOT

![pic](http://ww3.sinaimg.cn/large/a74ecc4cjw1e3wbw0fi4nj208w0dc3za.jpg)
![pic](http://ww1.sinaimg.cn/large/a74eed94jw1e3v9jldn2aj208w0dcwfw.jpg)
