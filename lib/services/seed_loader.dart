import '../models/models.dart';

const List<String> yesNo = ['بله', 'خیر'];
const List<String> yesPartialNoNA = ['بله', 'تا حدودی', 'خیر', 'نامشمول'];

class SeedLoader {
  static List<ChecklistItem> getChecklists() {
    return [fireBox, periodicHse, electrical];
  }

  static ChecklistItem? getByCode(String code) {
    for (final c in getChecklists()) {
      if (c.code == code) return c;
    }
    return null;
  }

  // ============================================================
  // چک لیست فایر باکس — HSE-6-022 V1 — نوع پاسخ: بله/خیر
  // ============================================================
  static const ChecklistItem fireBox = ChecklistItem(
    code: 'HSE-6-022',
    id: 'firebox',
    title: 'چک لیست فایر باکس',
    sections: [
      ChecklistSection(
        id: 'firebox-main',
        title: 'فایر باکس',
        questions: [
          QuestionDefinition(id: 'fb-1', text: 'جعبه از نظر شکل ظاهری سالم است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fb-2', text: 'شیر فلکه سالم است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fb-3', text: 'کوپلینگ اتصال به سر شیلنگ فشار قوی دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fb-4', text: 'عملکرد نازل در سه حالت درست است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fb-5', text: 'تست شیلنگ برزنتی بیست متری مورد قبول است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fb-6', text: 'خار قفلی کوپلینگ‌ها سالم است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fb-7', text: 'واشر آب‌بندی کوپلینگ دو سر آن را دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fb-8', text: 'قرقره از نظر شکل و کارکرد سالم است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fb-9', text: 'آچار مخصوص باز و بست کوپلینگ دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fb-10', text: 'کلید درب جعبه در محل خود قرار دارد؟', responseOptions: yesNo),
        ],
      ),
    ],
  );

  // ============================================================
  // چک لیست کنترل و ارزیابی ادواری HSE — HSE-6-027 V0 — بله/خیر
  // ============================================================
  static const ChecklistItem periodicHse = ChecklistItem(
    code: 'HSE-6-027',
    id: 'periodic',
    title: 'چک لیست کنترل و ارزیابی ادواری HSE',
    sections: [
      ChecklistSection(
        id: 'prod-hall',
        title: 'سالن تولید',
        questions: [
          QuestionDefinition(id: 'ph-1', text: 'جعبه کمک‌های اولیه با تجهیزات لازم در محل وجود دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-2', text: 'کارگران از تجهیزات حفاظت فردی استفاده می‌کنند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-3', text: 'نظم و نظافت سالن به خوبی انجام می‌شود؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-4', text: 'نظافت رختکن مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-5', text: 'نظافت سرویس‌های بهداشتی مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-6', text: 'نظافت غذاخوری مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-7', text: 'شستشوی آب‌سردکن‌ها و تانک‌های آب آشامیدنی انجام شده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-8', text: 'وضعیت دیوارها، کف، سقف و شیشه پنجره‌ها مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-9', text: 'جمع‌آوری و تفکیک زباله‌ها و ضایعات مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-10', text: 'کلیه قسمت‌های انتقال نیرو مانند تسمه، چرخ دنده و غیره حفاظ مناسب دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-11', text: 'سیستم ایمنی و قطع‌کن اضطراری ماشین‌آلات به نحو مؤثر کار می‌کند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-12', text: 'شیلنگ‌های هوای فشرده سالم و دارای بست مناسب می‌باشند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-13', text: 'قبل از شروع به تعمیر و سرویس‌کاری، ماشین‌آلات به طور مطمئنی متوقف می‌شوند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-14', text: 'ماشین‌آلات معیوب و یا در دست تعمیر با علایم هشداردهنده مشخص می‌شوند؟؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-15', text 'تجهیزات برقی مانند دریل و سنگ و غیره سالم و فاقد عیوب فنی و الکتریکی هستند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-16', text: 'مقابل تابلوهای برق کفپوش عایق نصب شده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-17', text: 'درب تابلوهای برق بسته است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-18', text: 'کلیه کلید و پریزها سالم و بدون عیب هستند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-19', text: 'کابل‌های برق سالم و بدون عیب هستند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-20', text: 'کلیه تجهیزات اطفای حریق کنترل ماهیانه شده‌اند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-21', text: 'اطراف تجهیزات اعلام و اطفای حریق باز است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-22', text: 'درها و مسیرهای خDefinition(id: 'طراری مشخص شده‌اند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-23', text: 'مقابل درها و مسیرهای خروجی اضطراری باز بوده و مسدود نشده‌اند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-24', text: 'MSDS مواد تهیه شده و در دسترس قرار دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-25', text: 'از نشت و ریزش مواد شیمیایی بر روی زمین به نحو مناسب جلوگیری شده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-26', text: 'محل نگهداری مواد شیمیایی دارای تهویه مناسب می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-27', text: 'کلیه پرتگاه‌ها و محل‌های سقوط، حفاظ‌گذاری شده‌اند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ph-28', text: 'خطرات ایمنی، بهداشتی و زیست‌محیطی شناسایی شده و تحت کنترل می‌باشند؟', responseOptions: yesNo),
        ],
      ),
      ChecklistSection(
        id: 'warehouse',
        title: 'انبار',
        questions: [
          QuestionDefinition(id: 'wh-1', text: 'انبار دارای خروجی‌های اضطراری مناسب بوده و این خروجی‌ها کاملاً باز است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-2', text: 'آراستگی در محل انبار رعایت شده و از ریخت و پاش مواد اجتناب شده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-3', text: 'اطراف ساختمان انبار از خار و خاشاک و یا مواد قابل اشتعال پاکسازی شده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-4', text: 'تجهیزات اطفای حریق کنترل ماهیانه شده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-5', text: 'کلیه کلید و پریزها و کابل‌ها سالم و بدون زدگی می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-6', text: 'کابل‌ها از داخل لوله‌های فلزی عبور کرده و یا از نوع حفاظ‌دار می‌باشند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-7', text: 'لامپ‌ها و سیستم روشنایی از نوع ایمن بوده و فاصله ایمنی از مواد قابل اشتعال دارند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-8', text: 'MSDS مواد تهیه، نصب و آموزش داده شده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-9', text: 'تاریخ انقضای مواد فاسد شدنی مورد توجه قرار می‌گیرد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-10', text: 'مواد بر اساس زمان تولید مصرف می‌شوند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-11', text: 'چیدمان کالا و بسته‌های مواد و قطعات مناسب و ایمن می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-12', text: 'آیا از نشتی روغن‌ها و سایر مواد شیمیایی جلوگیری می‌گردد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-13', text: 'کلیه پرتگاه‌ها و محل‌های سقوط حفاظ‌گذاری شده‌اند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'wh-14', text: 'خطرات ایمنی، بهداشتی و زیست‌محیطی شناسایی شده و تحت کنترل می‌باشند؟', responseOptions: yesNo),
        ],
      ),
      ChecklistSection(
        id: 'welding-shop',
        title: 'کارگاه جوشکاری',
        questions: [
          QuestionDefinition(id: 'ws-1', text: 'جعبه کمک‌های اولیه با تجهیزات لازم در محل وجود دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-2', text: 'نیروهای کارگاه جوشکاری از تجهیزات حفاظت فردی استفاده می‌کنند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-3', text: 'نظم و نظافت کارگاه به خوبی انجام می‌شود؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-4', text: 'جمع‌آوری و تفکیک زباله‌ها و ضایعات مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-5', text: 'کلیه قسمت‌های انتقال نیرو دارای حفاظ مناسب می‌باشند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-6', text: 'کلیه کلید و پریزها سالم و بدون عیب هستند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-7', text: 'کابل‌های برق سالم و بدون عیب هستند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-8', text: 'شیلنگ‌های هوای فشرده سالم و دارای بست مناسب می‌باشند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-9', text: 'کارگاه دارای تهویه مناسب می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-10', text: 'کلیه تجهیزات اطفای حریق کنترل ماهیانه شده‌اند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-11', text: 'کلیه قسمت‌های دستگاه‌های الکتریکی به سیستم اتصال زمین مجهز می‌باشند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-12', text: 'شیرها، بست‌ها و شیلنگ‌های متصل به سیلندرها سالم و ایمن هستند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-13', text: 'سیلندرهای گاز به صورت قائم و ایمن نگهداری و به کار برده می‌شوند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ws-14', text: 'خطرات ایمنی، بهداشتی و زیست‌محیطی شناسایی شده و تحت کنترل می‌باشند؟', responseOptions: yesNo),
        ],
      ),
      ChecklistSection(
        id: 'utilities-shop',
        title: 'کارگاه تاسیسات',
        questions: [
          QuestionDefinition(id: 'us-1', text: 'جعبه کمک‌های اولیه با تجهیزات لازم در محل وجود دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-2', text: 'کارگران از تجهیزات حفاظت فردی استفاده می‌کنند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-3', text: 'نظم و نظافت کارگاه به خوبی انجام می‌شود؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-4', text: 'جمع‌آوری و تفکیک زباله‌ها و ضایعات مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-5', text: 'از نشت و ریزش مواد شیمیایی و روغن‌های سوخته و مصرفی جلوگیری می‌شود؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-6', text: 'کلیه قسمت‌های انتقال نیرو دارای حفاظ مناسب می‌باشند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-7', text: 'کلیه کلید و پریزها سالم و بدون عیب هستند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-8', text: 'کابل‌های برق سالم و بدون عیب هستند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-9', text: 'شیلنگ‌های هوای فشرده سالم و دارای بست مناسب می‌باشند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-10', text: 'کلیه تجهیزات اطفای حریق کنترل ماهیانه شده‌اند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-11', text: 'درب تابلوهای برق بسته است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-12', text: 'مقابل تابلوهای برق کفپوش عایق نصب شده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-13', text: 'کلیه قسمت‌های دستگاه‌های الکتریکی به سیستم اتصال زمین مجهز می‌باشند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-14', text: 'سرویس و نگهداری دیگ‌های بخار و آب جوش طبق برنامه انجام می‌شود؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-15', text: 'سرویس و نگهداری پمپ‌های آب طبق برنامه انجام می‌شود؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-16', text: 'تست هیدرواستاتیک سالیانه دیگ‌های بخار و آب جوش انجام می‌شود؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-17', text: 'تست ضخامت‌سنجی بدنه دیگ‌های بخار و آب جوش در بازرسی سالیانه انجام می‌شود؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-18', text: 'فشارسنج‌ها (مانومترها) سالیانه یکبار کالیبره می‌شوند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-19', text: 'MSDS مواد تهیه شده و در دسترس قرار دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-20', text: 'خطرات ایمنی، بهداشتی و زیست‌محیطی شناسایی شده و تحت کنترل می‌باشند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'us-21', text: 'علایم ایمنی متناسب با خطرات محیط کار نصب شده است؟', responseOptions: yesNo),
        ],
      ),
      ChecklistSection(
        id: 'restaurant',
        title: 'رستوران',
        questions: [
          QuestionDefinition(id: 'rs-1', text: 'کلیه پرسنل دارای کارت سلامت می‌باشند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-2', text: 'پرسنل آشپزخانه، نظافت فردی را رعایت می‌نمایند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-3', text: 'پرسنل از کلاه، لباس‌کار و دستکش استفاده می‌کنند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-4', text: 'نظم و نظافت محیط آشپزخانه و رستوران به خوبی انجام می‌شود؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-5', text: 'جعبه کمک‌های اولیه با تجهیزات لازم در محل وجود دارد؟', responseOptions: وجود دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-6 ظروف پخت و پز و سرو غذا مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-7', text: 'نحوه نگهداری مواد غذایی مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-8', text: 'تاریخ مصرف مواد غذایی رعایت می‌شود؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-9', text: 'وضعیت ظرفشویی‌ها و کانال‌های آبرو مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-10', text: 'طوری درب‌ها و پنجره‌ها سالم است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-11', text: 'وضعیت دیوارها، کف، سقف و شیشه پنجره‌ها مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-12', text: 'شیرآلات و اتصالات آب و گاز سالم بوده و نشتی ندارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-13', text: 'جمع‌آوری و تفکیک زباله‌ها و ضایعات مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-14', text: 'کلیه کلید و پریزها سالم و بدون عیب هستند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-15', text: 'کابل‌های برق سالم و بدون عیب هستند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-16', text: 'تجهیزات اطفای حریق کنترل ماهیانه شده‌اند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-17', text: 'MSDS مواد تهیه شده و در دسترس قرار دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'rs-18', text: 'خطرات ایمنی، بهداشتی و زیست‌محیطی شناسایی شده و تحت کنترل می‌باشند؟', responseOptions: yesNo),
        ],
      ),
      ChecklistSection(
        id: 'yard',
        title: 'محوطه',
        questions: [
         اه‌(id: 'yd-1', text: 'وضعیت خروجی آبراه‌های سطحی مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'yd-2', text: 'وضعیت محل و نحوه نگهداری کپسول‌های گاز مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'yd-3', text: 'وضعیت نگهداری بشکه‌های بنزین مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'yd-4', text: 'وضعیت محل نگهداری مخازن گازوئیل مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'yd-5', text: 'جمع‌آوری، تفکیک و نگهداری زباله‌ها و ضایعات مختلف کارخانه مناسب است', responseOptions: yesNo),
          QuestionDefinition(id: 'yd-6', text: 'نگهداری فضای سبز مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'yd-7', text: 'نظم و نظافت محوطه کارخانه مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'yd-8', text: 'خطرات ایمنی، بهداشتی و زیست‌محیطی شناسایی شده و تحت کنترل می‌باشند؟', responseOptions: yesNo),
        ],
      ),
      ChecklistSection(
        id: 'forklift',
        title: 'لیفتراک',
        questions: [
          QuestionDefinition(id: 'fl-1', text: 'آیا لیفتراک مجهز به کپسول اطفاء حریق است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fl-2', text: 'آیا شاخک‌های لیفتراک سالم و بدون نقص است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fl-3', text: 'آیا چراغ‌های جلو و عقب لیفتراک سالم است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fl-4', text: 'آیا آژیر دنده عقب لیفتراک سالم و در حین کار عمل می‌کند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fl-5', text: 'آیا وضعیت لاستیک‌ها، چرخ‌ها و بدنه لیفتراک سالم است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fl-6', text: 'آیا آینه‌های لیفتراک سالم است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fl-7', text: 'آیا صندلی سالم و فاقد شکستگی است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fl-8', text: 'آیا بست نگهدارنده سیلندر سوخت و کپسول اطفای حریق سالم است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fl-9', text: 'آیا اتصالات شیلنگ روغن لیفتراک سالم و بدون نشتی و روغن‌ریزی است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fl-10', text: 'آیا ترمز، فرمان و دستگاه‌های کنترلی لیفتراک سالم است و درست کار می‌کند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'fl-11', text: 'آیا کابین لیفتراک مسقف است؟', responseOptions: yesNo),
        ],
      ),
    ],
  );

  // ============================================================
  // چک‌لیست ایمنی برق — HSE-6-028 V0
  // ============================================================
  static const ChecklistItem electrical = ChecklistItem(
    code: 'HSE-6-028',
    id: 'electrical',
    title: 'چک‌لیست ایمنی برق',
    sections: [
      ChecklistSection(
        id: 'elec-general',
        title: 'ایمنی برق عمومی',
        questions: [
          QuestionDefinition(id: 'eg-1', text: 'آیا کلیه وسایل الکتریکی و ادوات برقی مثل کلیدها، پریزها و غیره سالم هستند؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-2', text: 'آیا سیم‌کشی مطابق اصول فنی می‌باشد؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-3', text: 'آیا سیم‌کشی غیرمجاز وجود دارد؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-4', text: 'آیا سیم‌ها از داخل لوله‌های عایق یا سینی برق عبور داده شده‌اند؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-5', text: 'آیا سر راه جریان برق دستگاه‌ها، فیوز سالم و متناسب قرار دارد؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-6', text: 'آیا هنگام تعمیرات از ابزار و وسایل ایمنی عایق استفاده می‌شود؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-7', text: 'آیا تعمیرات برق توسط افراد مسئول و متخصص انجام می‌شود؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-8', text: 'آیا هنگام تعمیرات دستگاه‌های برقی، فیوزهای تابلو برق مربوط بهب می‌شود؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-9', text: 'آیا کابل‌های دستگاه الکتریکی از کابل‌های دستگاه‌های خبرکننده مانند کاشف‌ها (detector) جدا می‌باشد؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-10', text: 'آیا نکات ایمنی در خصوص سیم‌های سیار رعایت می‌شود؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-11', text: 'آیا از وسایل حفاظت فردی مناسب در هنگام کار با وسایل برقی استفاده می‌شود text: responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-12', text: 'آیا کارگران برق‌کار، آموزش‌های لازم در مورد ایمنی برق و کمک‌های اولیه را دیده‌اند؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-13', text: 'آیا سیستم اتصال به زمین، چاه ارت و دستگاه ارت وجود دارد؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-14', text: 'آیا تمام دستگاه‌ها و تابلوهای برق به سیستم ارت متصل هستند و سیم اتصال به زمین به صورت دوره‌ای چک می‌شود؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-15', text: 'آیا مقاومت چاه ارت به صورت دوره‌ای ارزیابی می‌گیرد؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-16', text: 'آیا نکات ایمنی در هنگام کار در مکان‌های مرطوب رعایت می‌گردد؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-17', text: 'آیا قبل از استفاده از وسایل و ابزارآلات برقی، کنترل ایمنی آن‌ها صورت می‌گیرد؟ (زدگی، پارگی و غیره نداشته باشد)', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-18', text: 'آیا قبل از استفاده از وسایل برقی ولتاژ آن کنترل می‌شود؟ (آیا تمام دستگاهل می‌شود؟ (آیا تمام دستگاه‌ها نشانگر ولتاژ دارند QuestionDefinition(id: 'eg-19', text: 'آیا سیستم برق‌گیر نصب شده است و کارگاه را به صورت مناسب تحت پوشش قرار می‌دهد؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-20', text: 'آیا نگهداری تجهیزات الکتریکی نصب شده به صورت دوره‌ای صورت می‌گیرد؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-21', text: 'آیا کلیدهای الکتریکی دستگاه‌ها برچسب‌های مناسب شناسایی دارند؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-22', text: 'آیا دستورالعمل‌های مناسب ایمنی برق وجود دارد و رعایت می‌گردد؟', responseOptions: yesPartialNoNA),
          QuestionDefinition(id: 'eg-23', text: 'آموزش‌های لازم در خصوص ایمنی برق و کمک‌های اولیه در هنگام برق‌گرفتگی داده شده است؟', responseOptions: yesPartialNoNA),
        ],
      ),
      ChecklistSection(
        id: 'elec-panels',
        title: 'ایمنی تابلوهای برق',
        questions: [
          QuestionDefinition(id: 'ep-1', text: 'تابلوهای برق سالم می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-2', text: 'محل قرار گرفتن تابلوهای برق مناسب است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-3', text: 'تابلوهای برق در محفظه قفل‌دار مخصوص قرار دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-4', text: 'تابلو برق در اختیار فرد مسئول و مورد بازرسی مستمر می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-5', text: 'اطراف تابلو برق فضای کافی (۱.۵ متر مربع) دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-6', text: 'توصیه‌های ایمنی لازم در مجاورت تابلو نصب گردیده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-7', text: 'درب تابلو مجهز به قفل مخصوص می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-8', text: 'تابلوهای (پی ال سی) دارای کلید حفاظتی (جهت جلوگیری از وقوع حوادث) می‌باشند؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-9', text: 'فرش لاستیکی یا سکوی عایق در کنار تابلو موجود دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-10', text: 'اطفاءکننده حریق متناسب در کنار تابلو (ترجیحاً کپسول اطفاء انیدرید کربنیک) دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-11', text: 'کابل‌کشی استاندارد و مسیر سیم‌ها در تابلو قابل ردیابی می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-12', text: 'تابلو دارای سیستم اتصال به زمین می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-13', text: 'تابلو مجهز به سایر سیستم‌های حفاظتی مناسب (آژیر، بیمتال و غیره) می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(idNo),
          QuestionDefinition(id: 'ep-14', text: 'فاصله پایین تابلو کنار ترمینال مجاز (۳۵ سانتی‌متر) می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-15', text: 'گلند جهت ورود سیم به داخل تابلو نصب شده گردیده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-16', text: 'پلاگ یا جسم مناسب (سوراخ‌بند) برای پوشش سوراخ‌های باز و اضافی تابلو موجود دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-17', text: 'موقعیت کلیدها و نشانگرها در تابلو به لحاظ ایجاد فاصله لازم هنگام کار مناسب می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-18', text: 'برچسب‌های علامت‌گذاری کابل‌های مدار تابلو مناسب می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-19', text: 'فیوزها و کلیدهای خودکار متناسب با ولتاژ و جریان عبوری شبکه موجود دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-20', text: 'روشنایی عمومی و موضعی تابلو مناسب می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'ep-21', text: 'محافظ‌هایی جهت تجهیزات الکتریکی حساس روی تابلو در نظر گرفته شده است؟', responseOptions: yesNo),
        ],
      ),
      ChecklistSection(
        id: 'elec-substation',
        title: 'ایمنی تابلوهای پست برق ۲۰ کیلوولت',
        questions: [
          QuestionDefinition(id: 'es-1', text: 'در دو طرف تابلو برق فشار قوی، حداقل ۶۰ سانتی‌Definition(id: 'وار فاصله وجود دارد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'es-2', text: 'فاصله جلوی تابلو تا دیوار ۱۳۰ سانتی‌متر می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'es-3', text: 'ارتفاع از کف پست برق تا روشنایی سقف حداقل ۱۹۰ سانتی‌متر می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'es-4', text: 'حداقل فضای دسترسی از رو به رو تابلو ۷۵ سانتی‌متر است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'es-5', text: 'فاصله بالای تابلو (به ارتفاع ۱۹۰ سانتی‌متر تا سقف)، حداقل ۹۰ سانتی‌متر است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'es-6', text: 'بر روی تابلو برق (علامت-نوشته) توجه ولتاژ بالا نصب یا نوشته شده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'es-7', text: 'جنب تابلو، خاموش‌کننده حریق انیدرید کربنیک نصب شده است؟', responseOptions: yesNo),
          QuestionDefinition(id: 'es-8', text: 'فرش عایق متناسب با ولتاژ، جلوی تابلو وجود دارد؟', responseOptions: yesNo),
          Question ایمنی (کلاس B) و چکدستکش و کلاه ایمنی (کلاس B) و چکمه عایق الکتریسیته و هندل مخصوص (جهت شارژ)، فازمتر متناسب با ولتاژ برق در دسترس می‌باشد؟', responseOptions: yesNo),
          QuestionDefinition(id: 'es-10', te
