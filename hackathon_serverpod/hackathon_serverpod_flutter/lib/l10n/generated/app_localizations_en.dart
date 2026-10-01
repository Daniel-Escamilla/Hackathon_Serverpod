// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Chores prototype';

  @override
  String get retry => 'Try again';

  @override
  String get coinsLabel => 'coins';

  @override
  String get reject => 'Reject';

  @override
  String get decreaseAmount => 'Decrease';

  @override
  String get increaseAmount => 'Increase';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navShop => 'Shop';

  @override
  String get navWallet => 'Wallet';

  @override
  String get navGroup => 'Group';

  @override
  String get proposeTask => 'Propose';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activityEmptyMessage =>
      'You\'ll see what the others do here while the app is open.';

  @override
  String get activitySomeone => 'Someone';

  @override
  String activityTaskProposed(String name) {
    return '$name proposed a task';
  }

  @override
  String activityTaskVoteCast(String name) {
    return '$name voted on a task';
  }

  @override
  String activityTaskCounterOffered(String name) {
    return '$name made a counter-offer';
  }

  @override
  String activityTaskClaimed(String name) {
    return '$name says a task is done';
  }

  @override
  String activityTaskValidated(String name) {
    return '$name voted on whether a task is done';
  }

  @override
  String activityRewardProposed(String name) {
    return '$name proposed a reward';
  }

  @override
  String activityRewardVoteCast(String name) {
    return '$name voted on a reward';
  }

  @override
  String activityPurchased(String name) {
    return '$name bought a reward';
  }

  @override
  String activityPurchaseResponded(String name) {
    return '$name answered a purchase';
  }

  @override
  String activityPurchaseDelivered(String name) {
    return '$name delivered a purchase';
  }

  @override
  String activityMemberExpelled(String name) {
    return '$name expelled a member';
  }

  @override
  String activityMemberUpdated(String name) {
    return '$name changed their name or avatar';
  }

  @override
  String get activityJustNow => 'Just now';

  @override
  String activityMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String activityHoursAgo(int hours) {
    return '$hours h ago';
  }

  @override
  String get groupCheckError => 'Couldn\'t check your group.';

  @override
  String get welcomeHeadline => 'Chores,\nfair at last.';

  @override
  String get welcomeSubtitle => 'House deals are decided by everyone.';

  @override
  String get welcomeSignIn => 'Sign in with email';

  @override
  String get welcomeCreateAccount => 'Create an account';

  @override
  String get welcomeGoogle => 'Sign in with Google';

  @override
  String get googleSignInError => 'Couldn\'t sign in with Google.';

  @override
  String get googleSignInPopupBlocked =>
      'Your browser blocked the Google window. Allow pop-ups for this site and try again.';

  @override
  String get signInTitle => 'Sign in to your account';

  @override
  String get emailFieldLabel => 'Email';

  @override
  String get emailHint => 'mayte@email.com';

  @override
  String get passwordFieldLabel => 'Password';

  @override
  String get passwordHint => '••••••••';

  @override
  String get signInSubmit => 'Sign in';

  @override
  String get signInErrorInvalidCredentials => 'Wrong email or password.';

  @override
  String get authErrorTooManyAttempts =>
      'Too many attempts. Try again in a few minutes.';

  @override
  String get signInErrorUnknown => 'Couldn\'t sign in.';

  @override
  String get createAccountTitle => 'Create your account';

  @override
  String get createAccountContinue => 'Continue';

  @override
  String get createAccountErrorGeneric =>
      'Couldn\'t start the sign-up. Do you already have an account with that email?';

  @override
  String get createAccountErrorStart => 'Couldn\'t start the sign-up.';

  @override
  String get createAccountErrorRegistered =>
      'That email already has an account. Sign in.';

  @override
  String get verifyEmailTitle => 'Check your email';

  @override
  String verifyEmailSubtitle(String email) {
    return 'We\'ve sent a verification code to $email.';
  }

  @override
  String get codeHint => '284619';

  @override
  String get verifyButton => 'Verify';

  @override
  String get codeErrorExpired => 'The code has expired. Start again.';

  @override
  String get codeErrorInvalid => 'Wrong code.';

  @override
  String get codeErrorGeneric => 'Couldn\'t verify the code.';

  @override
  String get choosePasswordTitle => 'Choose a password';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get passwordErrorPolicy =>
      'The password doesn\'t meet the requirements.';

  @override
  String get passwordErrorExpired =>
      'The sign-up session has expired. Start again.';

  @override
  String get passwordErrorGeneric => 'Couldn\'t create the account.';

  @override
  String get forgotPasswordLink => 'Forgot your password?';

  @override
  String get resetPasswordTitle => 'Recover your password';

  @override
  String get resetPasswordSubtitle =>
      'We\'ll send you a code to choose a new one.';

  @override
  String get resetPasswordSendCode => 'Send code';

  @override
  String get newPasswordTitle => 'Choose a new password';

  @override
  String get newPasswordButton => 'Change password';

  @override
  String get passwordChanged => 'Password changed. Sign in with the new one.';

  @override
  String get groupChoiceGreeting => 'Hi!';

  @override
  String get groupChoiceQuestion => 'How do you want\nto start?';

  @override
  String get createGroupTitle => 'Create a group';

  @override
  String get createGroupSubtitle => 'Set up your space';

  @override
  String get joinGroupTitle => 'Join with a code';

  @override
  String get joinGroupCardSubtitle => 'Enter an existing group';

  @override
  String get createGroupHeadline => 'Create your group';

  @override
  String get createGroupHint => 'Choose how you share a home';

  @override
  String get profileSharedFlat => 'Shared flat';

  @override
  String get profileCouple => 'Couple';

  @override
  String get profileFamily => 'Family';

  @override
  String get groupNameLabel => 'Group name';

  @override
  String get groupNameHint => 'Mayte and Juan\'s place';

  @override
  String get createGroupSubmit => 'Create group';

  @override
  String get createGroupErrorEmpty => 'Give the group a name.';

  @override
  String get createGroupErrorGeneric => 'Couldn\'t create the group.';

  @override
  String get joinGroupHeadline => 'Join your people';

  @override
  String get joinGroupSubtitle => 'Enter the code you were given.';

  @override
  String get joinGroupCodeHint => 'NEST-482';

  @override
  String get joinGroupCaseNote => 'The code isn\'t case-sensitive';

  @override
  String get joinGroupSubmit => 'Join the group';

  @override
  String get joinGroupError => 'No group found with that code.';

  @override
  String get groupSuccessTitle => 'You\'ve got a home!';

  @override
  String get groupCodeLabel => 'Group code';

  @override
  String get shareCode => 'Share code';

  @override
  String get goToTasks => 'Go to tasks';

  @override
  String get groupPendingNotice =>
      'Sample data: there\'s no endpoint yet to ask the server for your group and its members.';

  @override
  String get membersTitle => 'Members';

  @override
  String get groupSettings => 'Group settings';

  @override
  String get groupSettingsFineLabel => 'Fine';

  @override
  String get groupSettingsFineHint =>
      'What someone who gets fined pays, as a share of the task\'s or the reward\'s value.';

  @override
  String groupSettingsFineValue(int percent) {
    return '$percent %';
  }

  @override
  String get groupSettingsSave => 'Save changes';

  @override
  String get groupSettingsSaved => 'Settings saved.';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get copyCode => 'Copy code';

  @override
  String get tasksLoadError => 'Couldn\'t load the tasks.';

  @override
  String get tasksEmpty => 'No tasks yet. Propose the first one.';

  @override
  String get sectionAwaitingVote => 'Waiting for your vote';

  @override
  String get sectionAvailable => 'Available';

  @override
  String get statusProposal => 'Proposal';

  @override
  String get statusCounterOffer => 'Counter-offer';

  @override
  String get statusAvailable => 'Available';

  @override
  String get statusValidation => 'Validation';

  @override
  String get waitingYourVote => 'Waiting for your vote';

  @override
  String get votingClosingSoon => 'The vote is about to close';

  @override
  String remainingTime(int hours, int minutes) {
    return '$hours h $minutes min left';
  }

  @override
  String get approve => 'Approve';

  @override
  String get counterOffer => 'Counter-offer';

  @override
  String get voteApproved => 'You approved the proposal';

  @override
  String get voteRejected => 'Proposal rejected';

  @override
  String get voteError => 'Couldn\'t record your vote';

  @override
  String get counterOfferError => 'Couldn\'t send the counter-offer';

  @override
  String get counterOfferSheetTitle => 'Make a counter-offer';

  @override
  String get counterOfferSheetSubtitle => 'How many coins would feel fair?';

  @override
  String get counterOfferPauseNotice =>
      'The vote will pause until the author answers';

  @override
  String get sendCounterOffer => 'Send counter-offer';

  @override
  String get counterOfferPausedStatus => 'Vote paused';

  @override
  String get counterOfferDecisionNotice =>
      'Someone counter-offered a new price for this task. If you accept, the vote starts over at that figure.';

  @override
  String get acceptCounterOffer => 'Accept the counter-offer';

  @override
  String get withdrawNoFine => 'Withdraw without a fine';

  @override
  String get counterOfferAccepted => 'Counter-offer accepted';

  @override
  String get proposalWithdrawn => 'Proposal withdrawn';

  @override
  String get counterOfferDecisionError => 'Couldn\'t process your decision';

  @override
  String get notReserved => 'It isn\'t reserved: claim it once it\'s done';

  @override
  String get markDone => 'It\'s done';

  @override
  String get claimedTitle => 'Claimed!';

  @override
  String get claimedMessage => 'Now the group has to confirm it\'s done.';

  @override
  String inValidationValue(int reward) {
    String _temp0 = intl.Intl.pluralLogic(
      reward,
      locale: localeName,
      other: '$reward coins',
      one: '1 coin',
    );
    return 'In validation · $_temp0';
  }

  @override
  String get backToTasks => 'Back to tasks';

  @override
  String get claimError =>
      'Couldn\'t claim it. Someone else may have taken it already.';

  @override
  String get claimTaken =>
      'Someone beat you to it: another person already took it.';

  @override
  String get validationQuestion =>
      'Is it really done? If most say yes, the reward is paid.';

  @override
  String get validationYourOwn =>
      'You claimed it: now the group decides whether it\'s done.';

  @override
  String get validationApprove => 'Yes, it\'s done';

  @override
  String get validationDeny => 'It isn\'t done';

  @override
  String get validationDenyTitle => 'Sure it isn\'t done?';

  @override
  String get validationDenyBody =>
      'If most vote no, whoever claimed it pays a fine and the task is available again.';

  @override
  String get validationApproved => 'You voted that it\'s done';

  @override
  String get validationDenied => 'You voted that it isn\'t done';

  @override
  String get newTaskTitle => 'New task';

  @override
  String get titleFieldLabel => 'Title';

  @override
  String get taskTitleHint => 'Clean the bathroom';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get taskDescriptionHint => 'Shower, sink, mirror and floor';

  @override
  String get rewardLabel => 'Reward';

  @override
  String get rewardHintNote => 'A normal task is usually worth 10';

  @override
  String get reviewProposal => 'Review proposal';

  @override
  String get taskTitleEmptyError => 'Give the task a title.';

  @override
  String get reviewDealStatus => 'Review the deal';

  @override
  String get voteWindowNotice => 'The group will have 24 hours to vote';

  @override
  String get rejectFineNotice =>
      'If it\'s rejected, you\'ll be fined a share of these coins';

  @override
  String get submitToVote => 'Send to vote';

  @override
  String get sentToVoteTitle => 'Sent to vote';

  @override
  String get sentToVoteMessage =>
      'We\'ll let the group know so they can decide on the deal.';

  @override
  String rewardAmount(int reward) {
    String _temp0 = intl.Intl.pluralLogic(
      reward,
      locale: localeName,
      other: '$reward coins',
      one: '1 coin',
    );
    return '$_temp0';
  }

  @override
  String get proposeError => 'Couldn\'t send the proposal';

  @override
  String get shopSubtitle => 'Turn your coins into plans';

  @override
  String get shopLoadError => 'Couldn\'t load the shop.';

  @override
  String get shopEmpty => 'No rewards yet. Propose the first one.';

  @override
  String get awaitingVoteSection => 'Waiting for a vote';

  @override
  String get awaitingYourVote => 'Waiting for your vote';

  @override
  String get approveReward => 'Approve reward';

  @override
  String get rewardApproved => 'Reward approved';

  @override
  String get rewardRejected => 'Reward rejected';

  @override
  String get newRewardTitle => 'New reward';

  @override
  String get rewardTitleHint => 'Breakfast in bed';

  @override
  String get rewardDescriptionHint => 'Coffee, toast and fruit';

  @override
  String get priceLabel => 'Price';

  @override
  String get rewardVotingNotice => 'The group will vote before it\'s published';

  @override
  String get rewardTitleEmptyError => 'Give the reward a title.';

  @override
  String get rewardSentToVote => 'Reward sent to vote';

  @override
  String get rewardSubmitError => 'Couldn\'t send the reward';

  @override
  String get whoWillFulfil => 'Who will fulfil it?';

  @override
  String get selectMember => 'Pick someone';

  @override
  String get noOtherMembers =>
      'There\'s nobody else in the group to fulfil it yet.';

  @override
  String notEnoughCoins(int missing, int balance, int price) {
    String _temp0 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: 'You\'re $missing coins short',
      one: 'You\'re 1 coin short',
    );
    return '$_temp0: you have $balance and this reward costs $price. Do some tasks to earn them.';
  }

  @override
  String get purchaseSentTitle => 'Purchase sent';

  @override
  String get purchaseSentMessage =>
      'They have to accept it before fulfilling it.';

  @override
  String get backToShop => 'Back to the shop';

  @override
  String get purchaseError => 'Couldn\'t complete the purchase';

  @override
  String get walletLoadError => 'Couldn\'t load the wallet.';

  @override
  String get negativeBalanceNotice =>
      'With a negative balance you can\'t buy in the shop, but you can keep doing tasks to recover.';

  @override
  String get recentMovements => 'Recent movements';

  @override
  String get noMovements => 'No movements yet.';

  @override
  String get reasonEarned => 'Task completed';

  @override
  String get reasonFined => 'Fine';

  @override
  String get reasonSpent => 'Shop purchase';

  @override
  String get reasonRefunded => 'Refund';

  @override
  String get reasonProposalDenied => 'Proposal rejected';

  @override
  String get reasonValidationDenied => 'Validation rejected';

  @override
  String get reasonVoteExpired => 'You didn\'t vote in time';

  @override
  String get cancel => 'Cancel';

  @override
  String get memberRoleAdmin => 'Admin';

  @override
  String get memberYou => 'You';

  @override
  String get expelAction => 'Expel';

  @override
  String expelTitle(String name) {
    return 'Expel $name?';
  }

  @override
  String get expelBody =>
      'They\'ll leave the group and lose their balance. What they did stays in everyone\'s history.';

  @override
  String expelDone(String name) {
    return '$name is no longer in the group.';
  }

  @override
  String get groupInviteRegenerate => 'Change the code';

  @override
  String get groupInviteRegenerateTitle => 'Change the code?';

  @override
  String get groupInviteRegenerateBody =>
      'The current code will stop working. Everyone already in the group stays in.';

  @override
  String get groupInviteRegenerated =>
      'Code changed. The old one no longer works.';

  @override
  String get errorInviteCode =>
      'That code doesn\'t exist. Check it with whoever gave it to you.';

  @override
  String get errorAlreadyInGroup =>
      'You\'re already in a group. Leave it before joining another.';

  @override
  String get errorNotAdmin => 'Only the group\'s admin can do this.';

  @override
  String get errorMemberNotFound => 'That person is no longer in the group.';

  @override
  String get errorCannotExpelSelf =>
      'You can\'t expel yourself from the group.';

  @override
  String get errorCannotTransferAdmin =>
      'The admin role can only go to another adult in the group.';

  @override
  String get errorTaskNotFound => 'That task no longer exists.';

  @override
  String get errorTaskNotOpen =>
      'This task has changed. Go back to the list to see it up to date.';

  @override
  String get errorOwnTask => 'You can\'t vote on your own task.';

  @override
  String get errorNotProposer =>
      'Only whoever proposed the task can answer the counter-offer.';

  @override
  String get errorRewardNotFound => 'That reward no longer exists.';

  @override
  String get errorRewardNotOpen =>
      'The vote on this reward has already closed.';

  @override
  String get errorOwnReward => 'You can\'t vote on your own reward.';

  @override
  String get errorRewardNotAvailable =>
      'This reward isn\'t in the shop right now.';

  @override
  String get errorOutOfStock => 'This reward is sold out.';

  @override
  String get errorNegativeBalance => 'You can\'t buy with a negative balance.';

  @override
  String get errorInvalidProvider =>
      'Pick someone else in the group to fulfil it.';

  @override
  String get errorPurchaseNotFound => 'That purchase no longer exists.';

  @override
  String get errorPurchaseNotOpen =>
      'This purchase has changed. Go back to the list to see it up to date.';

  @override
  String get errorNotProvider =>
      'Only whoever has to fulfil the purchase can answer or deliver it.';

  @override
  String get errorNoGroup => 'You\'re no longer in this group.';

  @override
  String get leftGroupNotice =>
      'You\'re no longer in the group. You can create another one or join with a code.';

  @override
  String get errorGeneric => 'Something went wrong. Try again.';

  @override
  String get purchasesToFulfil => 'Yours to fulfil';

  @override
  String get purchasesMine => 'Your purchases';

  @override
  String get purchaseUnknownReward => 'Reward';

  @override
  String get purchaseSomeone => 'Someone';

  @override
  String get purchaseAccept => 'Accept';

  @override
  String get purchaseRefuse => 'Refuse';

  @override
  String get purchaseRefuseTitle => 'Refuse to fulfil it?';

  @override
  String get purchaseRefuseNotice =>
      'If you refuse you pay a fine, and the buyer gets their coins back.';

  @override
  String get purchaseMarkDelivered => 'Mark as delivered';

  @override
  String get purchaseAccepted => 'Purchase accepted: now it\'s yours to fulfil';

  @override
  String get purchaseRefused => 'You refused: the fine has been charged';

  @override
  String get purchaseDelivered => 'Delivered. Well done!';

  @override
  String get purchaseStatusPendingApproval => 'Waiting for a guardian';

  @override
  String get purchaseStatusPending => 'To accept';

  @override
  String get purchaseStatusAccepted => 'Accepted';

  @override
  String get purchaseStatusDelivered => 'Delivered';

  @override
  String get purchaseStatusRefused => 'Refused';

  @override
  String purchaseBoughtBy(String name) {
    return 'Bought by $name';
  }

  @override
  String purchaseProvidedBy(String name) {
    return '$name has to fulfil it';
  }

  @override
  String get sectionYoursInValidation => 'Yours in validation';

  @override
  String get sectionInVoting => 'Being voted on';

  @override
  String get votersTitle => 'Who has voted';

  @override
  String get votersNone => 'Nobody has voted yet.';

  @override
  String get voteInFavour => 'For';

  @override
  String get voteAgainst => 'Against';

  @override
  String get ownProposalNotice =>
      'You proposed it: the rest of the group votes.';

  @override
  String get alreadyVotedNotice => 'You\'ve voted. The rest still have to.';

  @override
  String get counterOfferWaitingNotice =>
      'Whoever proposed it is deciding whether to accept the counter-offer.';

  @override
  String voteCounterOffer(int reward) {
    return 'Counter-offer: $reward';
  }

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutTitle => 'Sign out?';

  @override
  String get signOutBody =>
      'You\'ll go back to the start screen and can sign in with another account.';

  @override
  String get mySettings => 'My settings';

  @override
  String get profileSection => 'Your profile';

  @override
  String get avatarEmojiLabel => 'Your emoji';

  @override
  String get avatarColorLabel => 'Colour';

  @override
  String get avatarColorSky => 'Sky blue';

  @override
  String get avatarColorLime => 'Lime';

  @override
  String get avatarColorCoral => 'Coral';

  @override
  String get avatarColorViolet => 'Violet';

  @override
  String get avatarColorCream => 'Cream';

  @override
  String get displayNameLabel => 'Your name';

  @override
  String get displayNameHint => 'How the group will see you';

  @override
  String get displayNameEmptyError => 'Write a name.';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profileSaveError => 'Couldn\'t save the profile';

  @override
  String get accountSection => 'Account';

  @override
  String get changePassword => 'Change password';

  @override
  String get languageSection => 'Language';

  @override
  String get languageSystem => 'The phone\'s language';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get changePasswordTitle => 'Change your password';

  @override
  String get changePasswordSubtitle =>
      'We\'ll email you a code to confirm it\'s you. Once done, you\'ll have to sign in again with the new password.';

  @override
  String get soundSection => 'Sound';

  @override
  String get soundsToggle => 'App sounds';

  @override
  String get soundsToggleHint =>
      'The button pops, the coin, the fines and the alerts.';

  @override
  String get transferAdminAction => 'Make admin';

  @override
  String transferAdminTitle(String name) {
    return 'Hand the admin role to $name?';
  }

  @override
  String transferAdminBody(String name) {
    return '$name will be able to expel members, change the code and configure the group. You\'ll become a regular member, and only $name can give the role back.';
  }

  @override
  String get transferAdminConfirm => 'Hand over the role';

  @override
  String transferAdminDone(String name) {
    return '$name is now the group\'s admin.';
  }
}
