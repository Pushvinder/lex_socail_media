import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_friendz_zone/screens/user_profile/user_profile_controller.dart';
import 'package:video_player/video_player.dart';
import '../../config/app_config.dart';
import '../../widgets/full_screen_image_viewer.dart';
import '../message/chat_screen.dart';
import 'models/user_model.dart';
import 'widgets/profile_stat_item.dart';
import 'widgets/profile_tab_button.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isPhotosTab = true;

  final double coverImageHeightRatio = 0.27;
  final double avatarRadius = 45.0;
  final double avatarBorderWidth = 2.0;
  final double avatarLeftPadding = 20.0;

  late double avatarDiameterWithBorder;

  UserProfileController _userProfileController =
      Get.put(UserProfileController());

  @override
  void initState() {
    _userProfileController.getUserProfileDetail(widget.userId);

    super.initState();
    avatarDiameterWithBorder = (avatarRadius + avatarBorderWidth) * 2;
  }

  @override
  void dispose() {
    _userProfileController.disposeVideoControllers();
    super.dispose();
  }

  @override
  void didUpdateWidget(UserProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.user != oldWidget.user) {
    //   _initializeVideoControllers();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final user = widget.user;

    final screenHeight = MediaQuery.of(context).size.height;
    final coverHeight = screenHeight * coverImageHeightRatio;
    final double horizontalPadding = 20.0;
    final double avatarOverlap = avatarRadius + avatarBorderWidth / 2;
    final double avatarOuterDiameter = avatarRadius * 2 + avatarBorderWidth * 2;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Obx(
        () => _userProfileController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: AppColors.scaffoldBackgroundColor,
                    pinned: false,
                    expandedHeight: coverHeight + avatarOverlap,
                    stretch: true,
                    leading: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, top: 12.0, bottom: 0.0),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.secondaryColor.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(11),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secondaryColor
                                        .withOpacity(0.12),
                                    offset: const Offset(0, 4),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset(
                                  AppImages.backArrow,
                                  height: AppDimens.dimen12,
                                  width: AppDimens.dimen12,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            // Cover
                            CachedNetworkImage(
                              width: double.infinity,
                              height: coverHeight,
                              imageUrl:
                                  _userProfileController.user.data?.profile ??
                                      '',

                              // todo: user.coverImageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color:
                                    AppColors.greyShadeColor.withOpacity(0.5),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.black12,
                              ),
                            ),
                            // Gradient
                            // Container(
                            //   decoration: BoxDecoration(
                            //     gradient: LinearGradient(
                            //       begin: Alignment.topCenter,
                            //       end: Alignment.bottomCenter,
                            //       colors: [
                            //         Colors.black.withOpacity(0.0),
                            //         AppColors.scaffoldBackgroundColor.withOpacity(0.14),
                            //         AppColors.scaffoldBackgroundColor.withOpacity(0.9),
                            //         AppColors.scaffoldBackgroundColor,
                            //       ],
                            //       stops: const [0.0, 0.4, 0.96, 1.0],
                            //     ),
                            //   ),
                            // ),
                            // Visual Avatar
                            Positioned(
                              left: horizontalPadding,
                              bottom: -avatarOverlap,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => FullScreenImageViewer(
                                        images: [
                                          _userProfileController
                                                  .user.data?.profile ??
                                              '',
                                        ],

                                        //todo:  [user.avatarUrl],
                                        initialIndex: 0,
                                        heroTag: _userProfileController
                                                .user.data?.profile ??
                                            '',
                                        //todo: user.avatarUrl,
                                      ),
                                    ),
                                  );
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  shape: const CircleBorder(),
                                  elevation: 5,
                                  child: Hero(
                                    tag: _userProfileController
                                            .user.data?.profile ??
                                        '',
                                    //todo: user.avatarUrl,
                                    child: Container(
                                      width: avatarOuterDiameter,
                                      height: avatarOuterDiameter,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              AppColors.scaffoldBackgroundColor,
                                          width: avatarBorderWidth,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.13),
                                            blurRadius: 14,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: avatarRadius,
                                        backgroundColor:
                                            AppColors.greyShadeColor,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          _userProfileController
                                                  .user.data?.profile ??
                                              '',
                                          //todo:  user.avatarUrl
                                        ),
                                        onBackgroundImageError:
                                            (exception, stackTrace) {},
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // This Sliver contains the tap target positioned over the visual avatar
                  SliverToBoxAdapter(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -(avatarOuterDiameter - (avatarOverlap)),
                          left: horizontalPadding,
                          child: Container(
                              color: Colors.transparent, child: Container()
                              // TODO: UNCOMMENT
                              //  _AvatarTapOverlay(
                              //   avatarOuterDiameter: avatarOuterDiameter,
                              //   user: user,
                              // ),
                              ),
                        ),

                        // Content below the avatar area (Name, Bio, Stats, Tabs)
                        Padding(
                          padding: EdgeInsets.only(
                            top: 9,
                            left: horizontalPadding,
                            right: horizontalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Action buttons aligned to the right
                              // Align(
                              //   alignment: Alignment.topRight,
                              //   child: Row(
                              //     spacing: 12,
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       Visibility(
                              //         visible:!( _userProfileController.user.data?.isFriend ?? false),
                              //         child: Row(children: [
                              //           (_userProfileController.user.data?.friend_status??'') != 'pending' ? Container(
                              //             decoration: BoxDecoration(
                              //               color: AppColors.connectBg
                              //                   .withOpacity(0.08),
                              //               borderRadius:
                              //               BorderRadius.circular(12),
                              //             ),
                              //             padding: const EdgeInsets.symmetric(
                              //                 horizontal: 12, vertical: 8),
                              //             alignment: Alignment.center,
                              //             child: Text('Connect' ,
                              //               style: GoogleFonts.inter(
                              //                 fontSize: FontDimen.dimen13,
                              //                 fontWeight: FontWeight.w600,
                              //               )
                              //               ,),
                              //           ).asButton(onTap: (){
                              //             _userProfileController.sendConnectionRequest(_userProfileController.user.data?.id.toString() ?? '');
                              //             _userProfileController.user.data?.friend_status = 'pending';
                              //             setState(() {

                              //             });
                              //           }):Container(
                              //             decoration: BoxDecoration(
                              //               color: AppColors.connectBg
                              //                   .withOpacity(0.08),
                              //               borderRadius:
                              //               BorderRadius.circular(12),
                              //             ),
                              //             padding: const EdgeInsets.symmetric(
                              //                 horizontal: 12, vertical: 8),
                              //             alignment: Alignment.center,
                              //             child: Text('Pending' ,
                              //               style: GoogleFonts.inter(
                              //                 fontSize: FontDimen.dimen13,
                              //                 fontWeight: FontWeight.w600,
                              //               )
                              //               ,),
                              //           ),
                              //         //    _CircleImageAssetButton(
                              //         //   assetPath: AppImages.greenCheck,
                              //         //   bgColor:
                              //         //       AppColors.connectBg.withOpacity(0.08),
                              //         //   iconSize: 24,
                              //         //   onTap: () {},
                              //         // ),
                              //         // const SizedBox(width: 12),
                              //         // _CircleImageAssetButton(
                              //         //   assetPath: AppImages.rejectRed,
                              //         //   bgColor: AppColors.rejectBgColor
                              //         //       .withOpacity(0.08),
                              //         //   iconSize: 24,
                              //         //   onTap: () {},
                              //         // ),
                              //         ],),
                              //       ),

                              //       Visibility(
                              //         visible: !(_userProfileController.user.data?.isFriend ?? false),
                              //         child: Row(
                              //           children: [
                              //         Container(
                              //           decoration: BoxDecoration(
                              //             color: AppColors.connectBg
                              //                 .withOpacity(0.08),
                              //             borderRadius:
                              //                 BorderRadius.circular(12),
                              //           ),
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 12, vertical: 8),
                              //           alignment: Alignment.center,
                              //           child: Text('Connected' ,
                              //             style: GoogleFonts.inter(
                              //               fontSize: FontDimen.dimen13,
                              //               fontWeight: FontWeight.w600,
                              //             )
                              //             ,),
                              //         ),
                              //             SizedBox(width: 16,),
                              //             _CircleImageAssetButton(
                              //               assetPath: AppImages.sendIcon,
                              //               bgColor: AppColors.bgColor,
                              //               iconSize: 17,
                              //               onTap: () {
                              //                 Get.to(
                              //                   () => ChatScreen(

                              //                     userName: _userProfileController
                              //                             .user.data?.fullname ??
                              //                         '',
                              //                     otherUserId: _userProfileController
                              //                             .user.data?.id
                              //                             .toString() ??
                              //                         '',
                              //                     userAvatar: _userProfileController
                              //                             .user.data?.profile ??
                              //                         '',
                              //                     isOnline: false,
                              //                   ),
                              //                 );
                              //               },
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Action buttons aligned to the right
                              Align(
                                alignment: Alignment.topRight,
                                child: Row(
                                  spacing: 12,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // State 1: Not friends and no pending request
                                    if (!(_userProfileController
                                                .user.data?.isFriend ??
                                            false) &&
                                        (_userProfileController
                                                    .user.data?.friend_status ??
                                                '') !=
                                            'pending')
                                      Row(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.connectBg
                                                .withOpacity(0.08),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          alignment: Alignment.center,
                                          child: Text('Connect',
                                              style: GoogleFonts.inter(
                                                fontSize: FontDimen.dimen13,
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ).asButton(onTap: () {
                                          _userProfileController
                                              .sendConnectionRequest(
                                                  _userProfileController
                                                          .user.data?.id
                                                          .toString() ??
                                                      '');
                                          _userProfileController.user.data
                                              ?.friend_status = 'pending';
                                          setState(() {});
                                        }),
                                        SizedBox(width: 16),
                                        _CircleImageAssetButton(
                                          assetPath: AppImages.sendIcon,
                                          bgColor: AppColors.bgColor,
                                          iconSize: 17,
                                          onTap: () {
                                            Get.to(
                                              () => ChatScreen(
                                                userName: _userProfileController
                                                        .user.data?.fullname ??
                                                    '',
                                                otherUserId:
                                                    _userProfileController
                                                            .user.data?.id
                                                            .toString() ??
                                                        '',
                                                userAvatar:
                                                    _userProfileController.user
                                                            .data?.profile ??
                                                        '',
                                                isOnline: false,
                                              ),
                                            );
                                          },
                                        ),
                                      ]),

                                    // State 2: Pending request
                                    if (!(_userProfileController
                                                .user.data?.isFriend ??
                                            false) &&
                                        (_userProfileController
                                                    .user.data?.friend_status ??
                                                '') ==
                                            'pending')
                                      Row(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.connectBg
                                                .withOpacity(0.08),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          alignment: Alignment.center,
                                          child: Text('Pending',
                                              style: GoogleFonts.inter(
                                                fontSize: FontDimen.dimen13,
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ),
                                        SizedBox(width: 16),
                                        _CircleImageAssetButton(
                                          assetPath: AppImages.sendIcon,
                                          bgColor: AppColors.bgColor,
                                          iconSize: 17,
                                          onTap: () {
                                            Get.to(
                                              () => ChatScreen(
                                                userName: _userProfileController
                                                        .user.data?.fullname ??
                                                    '',
                                                otherUserId:
                                                    _userProfileController
                                                            .user.data?.id
                                                            .toString() ??
                                                        '',
                                                userAvatar:
                                                    _userProfileController.user
                                                            .data?.profile ??
                                                        '',
                                                isOnline: false,
                                              ),
                                            );
                                          },
                                        ),
                                      ]),

                                    // State 3: Connected/Friends
                                    if (_userProfileController
                                            .user.data?.isFriend ??
                                        false)
                                      Row(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.connectBg
                                                .withOpacity(0.08),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          alignment: Alignment.center,
                                          child: Text('Connected',
                                              style: GoogleFonts.inter(
                                                fontSize: FontDimen.dimen13,
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ),
                                        SizedBox(width: 16),
                                        _CircleImageAssetButton(
                                          assetPath: AppImages.sendIcon,
                                          bgColor: AppColors.bgColor,
                                          iconSize: 17,
                                          onTap: () {
                                            Get.to(
                                              () => ChatScreen(
                                                userName: _userProfileController
                                                        .user.data?.fullname ??
                                                    '',
                                                otherUserId:
                                                    _userProfileController
                                                            .user.data?.id
                                                            .toString() ??
                                                        '',
                                                userAvatar:
                                                    _userProfileController.user
                                                            .data?.profile ??
                                                        '',
                                                isOnline: false,
                                              ),
                                            );
                                          },
                                        ),
                                      ]),
                                  ],
                                ),
                              ),
// Action buttons aligned to the right
                              // Align(
                              //   alignment: Alignment.topRight,
                              //   child: Row(
                              //     spacing: 12,
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       // Connect button (only when not friends and not pending)
                              //       Visibility(
                              //         visible: !(_userProfileController
                              //                     .user.data?.isFriend ??
                              //                 false) &&
                              //             (_userProfileController.user.data
                              //                         ?.friend_status ??
                              //                     '') !=
                              //                 'pending',
                              //         child: Container(
                              //           decoration: BoxDecoration(
                              //             color: AppColors.connectBg
                              //                 .withOpacity(0.08),
                              //             borderRadius:
                              //                 BorderRadius.circular(12),
                              //           ),
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 12, vertical: 8),
                              //           alignment: Alignment.center,
                              //           child: Text('Connect',
                              //               style: GoogleFonts.inter(
                              //                 fontSize: FontDimen.dimen13,
                              //                 fontWeight: FontWeight.w600,
                              //               )),
                              //         ).asButton(onTap: () {
                              //           _userProfileController
                              //               .sendConnectionRequest(
                              //                   _userProfileController
                              //                           .user.data?.id
                              //                           .toString() ??
                              //                       '');
                              //           _userProfileController.user.data
                              //               ?.friend_status = 'pending';
                              //           setState(() {});
                              //         }),
                              //       ),

                              //       // Pending button (only when not friends but pending)
                              //       Visibility(
                              //         visible: !(_userProfileController
                              //                     .user.data?.isFriend ??
                              //                 false) &&
                              //             (_userProfileController.user.data
                              //                         ?.friend_status ??
                              //                     '') ==
                              //                 'pending',
                              //         child: Container(
                              //           decoration: BoxDecoration(
                              //             color: AppColors.connectBg
                              //                 .withOpacity(0.08),
                              //             borderRadius:
                              //                 BorderRadius.circular(12),
                              //           ),
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 12, vertical: 8),
                              //           alignment: Alignment.center,
                              //           child: Text('Pending',
                              //               style: GoogleFonts.inter(
                              //                 fontSize: FontDimen.dimen13,
                              //                 fontWeight: FontWeight.w600,
                              //               )),
                              //         ),
                              //       ),

                              //       // Connected status and Message button (only when friends)
                              //       Visibility(
                              //         visible: (_userProfileController
                              //                 .user.data?.isFriend ??
                              //             false),
                              //         child: Row(
                              //           children: [
                              //             Container(
                              //               decoration: BoxDecoration(
                              //                 color: AppColors.connectBg
                              //                     .withOpacity(0.08),
                              //                 borderRadius:
                              //                     BorderRadius.circular(12),
                              //               ),
                              //               padding: const EdgeInsets.symmetric(
                              //                   horizontal: 12, vertical: 8),
                              //               alignment: Alignment.center,
                              //               child: Text('Connected',
                              //                   style: GoogleFonts.inter(
                              //                     fontSize: FontDimen.dimen13,
                              //                     fontWeight: FontWeight.w600,
                              //                   )),
                              //             ),
                              //             SizedBox(width: 16),
                              //             _CircleImageAssetButton(
                              //               assetPath: AppImages.sendIcon,
                              //               bgColor: AppColors.bgColor,
                              //               iconSize: 17,
                              //               onTap: () {
                              //                 Get.to(
                              //                   () => ChatScreen(
                              //                     userName:
                              //                         _userProfileController
                              //                                 .user
                              //                                 .data
                              //                                 ?.fullname ??
                              //                             '',
                              //                     otherUserId:
                              //                         _userProfileController
                              //                                 .user.data?.id
                              //                                 .toString() ??
                              //                             '',
                              //                     userAvatar:
                              //                         _userProfileController
                              //                                 .user
                              //                                 .data
                              //                                 ?.profile ??
                              //                             '',
                              //                     isOnline: false,
                              //                   ),
                              //                 );
                              //               },
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              const SizedBox(height: 5),
                              // Name, Age, Username
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 2.0, bottom: 2.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${_userProfileController.user.data?.fullname ?? ''}, ${_userProfileController.calculateAge(_userProfileController.user.data?.dob ?? "06-12-2006")} ',
                                        style: GoogleFonts.inter(
                                          color: AppColors.textColor3
                                              .withOpacity(1),
                                          fontSize: FontDimen.dimen15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '@${_userProfileController.user.data?.username ?? ''}',

                                        //TODO: '@${user.username}',
                                        style: GoogleFonts.inter(
                                          color: AppColors.textColor4
                                              .withOpacity(1),
                                          fontSize: FontDimen.dimen13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Bio
                              Text(
                                _userProfileController.user.data?.bio ?? '',
                                //  todo: user.bio,
                                style: GoogleFonts.inter(
                                  color: AppColors.textColor3.withOpacity(0.7),
                                  fontSize: FontDimen.dimen12,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 14),
                              // Stats
                              Row(
                                children: [
                                  ProfileStatItem(
                                      label: AppStrings.profilePosts,
                                      value: _userProfileController
                                              .user.data?.postCount ??
                                          ''
                                      // todo: user.posts.toString(),
                                      ),
                                  const SizedBox(width: 16),
                                  ProfileStatItem(
                                      label: AppStrings.profileConnections,
                                      value: _userProfileController
                                              .user.data?.connCount ??
                                          ''
                                      // todo: user.connections.toString(),
                                      ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Tabs
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.cardBehindBg.withOpacity(0.0),
                                  border: Border.all(
                                      color: AppColors.tabBorderColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    ProfileTabButton(
                                      label: AppStrings.profilePhotos,
                                      selected: isPhotosTab,
                                      onTap: () => setState(
                                        () => isPhotosTab = true,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    ProfileTabButton(
                                      label: AppStrings.profileVideos,
                                      selected: !isPhotosTab,
                                      onTap: () => setState(
                                        () => isPhotosTab = false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- GRID VIEW ---
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 12,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                        childAspectRatio: 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        childCount: isPhotosTab
                            ? _userProfileController.imagePostList.value.length
                            : _userProfileController.videoPostList.value.length,
                        (BuildContext context, int index) {
                          // photos post tab grid view
                          if (isPhotosTab) {
                            if (index >=
                                _userProfileController.imagePostList.value
                                    .length) return const SizedBox.shrink();
                            final imageUrl = _userProfileController
                                .imagePostList[index].imagepath?[0];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FullScreenImageViewer(
                                      images: _userProfileController
                                              .imagePostList[index].imagepath ??
                                          [],
                                      initialIndex: 0,
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: imageUrl ?? '',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        _buildGridLoadingPlaceholder(),
                                    errorWidget: (context, url, error) =>
                                        _buildGridErrorPlaceholder(
                                            "Image load failed"),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // Videos
                            if (index >=
                                    _userProfileController
                                        .videoPostList.length ||
                                index >=
                                    _userProfileController
                                        .videoControllers.length ||
                                index >=
                                    _userProfileController
                                        .isVideoInitialized.length ||
                                index >=
                                    _userProfileController
                                        .isVideoError.length) {
                              return _buildGridErrorPlaceholder(
                                  "Invalid video index");
                            }
                            final controller =
                                _userProfileController.videoControllers[index];
                            final isInitialized = _userProfileController
                                .isVideoInitialized[index];
                            final hadError =
                                _userProfileController.isVideoError[index];

                            if (hadError) {
                              return _buildGridErrorPlaceholder(
                                  "Video failed to load");
                            }
                            if (controller != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: controller
                                                  .value.isInitialized &&
                                              controller.value.aspectRatio > 0
                                          ? controller.value.aspectRatio
                                          : 1.0,
                                      child: VideoPlayer(controller),
                                    ),
                                    if (!isInitialized && !hadError)
                                      _buildGridLoadingPlaceholder(),
                                    if (isInitialized &&
                                        !controller.value.isPlaying)
                                      GestureDetector(
                                        onTap: () async {
                                          if (mounted) {
                                            if (controller.value.isPlaying) {
                                              await controller.pause();
                                            } else {
                                              await controller.play();
                                            }
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.black.withOpacity(0.3),
                                          child: const Center(
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 46,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            } else {
                              return _buildGridErrorPlaceholder(
                                  "Controller error");
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  // Bottom end padding
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 24,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGridLoadingPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBehindBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: CircularProgressIndicator(
            strokeWidth: 2, color: AppColors.textColor5.withOpacity(0.65)),
      ),
    );
  }

  Widget _buildGridErrorPlaceholder(String message) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBehindBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Tooltip(
        message: message,
        child: Center(
          child: Icon(Icons.error_outline,
              color: AppColors.greyColor.withOpacity(0.72), size: 30),
        ),
      ),
    );
  }
}

// Transparent overlay for accurate avatar tapping, part of the scrollable content
class _AvatarTapOverlay extends StatelessWidget {
  final double avatarOuterDiameter;
  final UserProfile user;

  const _AvatarTapOverlay({
    required this.avatarOuterDiameter,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FullScreenImageViewer(
              images: [user.data?.profile ?? ''],
              initialIndex: 0,
              heroTag: user.data?.profile ?? '',
            ),
          ),
        );
      },
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: avatarOuterDiameter,
        height: avatarOuterDiameter,
      ),
    );
  }
}

class _CircleImageAssetButton extends StatelessWidget {
  final String assetPath;
  final Color bgColor;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const _CircleImageAssetButton({
    required this.assetPath,
    required this.bgColor,
    required this.onTap,
    this.size = 38,
    this.iconSize = 22,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      shape: const CircleBorder(),
      elevation: 1.0,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Image.asset(
              assetPath,
              width: iconSize,
              height: iconSize,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.error,
                size: iconSize,
                color: AppColors.redColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
