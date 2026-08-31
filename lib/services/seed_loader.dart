import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // برای تولید IDهای منحصر به فرد

// --- مدل‌های تعریف چک‌لیست و سؤالات ---

/// نوع پاسخ برای هر سؤال.
enum QuestionResponseType {
  yesNo, // بله / خیر
  yesNoPartialNA, // بله / تا حدودی / خیر / نامشمول
  // در آینده می‌توان انواع دیگری مانند text, number, date, dropdown را اضافه کرد
}

/// تعریف یک سؤال در چک‌لیست.
class QuestionDefinition {
  final String id; // شناسه منحصر به فرد سؤال (مثلا: hse-6-027-saloon-prod-1)
  final String text; // متن سؤال
  final QuestionResponseType responseType; // نوع پاسخ مورد انتظار
  final List<String>? options; // گزینه‌های انتخابی (برای انواع پاسخ خاص)

  QuestionDefinition({
    required this.id,
    required this.text,
    required this.responseType,
    this.options,
  });
}

/// تعریف یک بخش (Section) در داخل یک چک‌لیست.
class ChecklistSection {
  final String id; // شناسه منحصر به فرد بخش (مثلا: hse-6-027-saloon-prod)
  final String title; // عنوان بخش (مثلا: "سالن تولید")
  final List<QuestionDefinition> questions; // لیستی از سؤالات این بخش

  ChecklistSection({
    required this.id,
    required this.title,
    required this.questions,
  });
}

/// تعریف یک چک‌لیست کامل.
class ChecklistItem {
  final String id; // شناسه منحصر به فرد چک‌لیست (مثلا: HSE-6-022)
  final String title; // عنوان اصلی چک‌لیست (مثلا: "چک لیست فایرباکس")
  final String category; // دسته‌بندی چک‌لیست (مثلا: "ایمنی فایرباکس")
  final List<ChecklistSection> sections; // لیستی از بخش‌های این چک‌لیست

  ChecklistItem({
    required this.id,
    required this.title,
    required this.category,
    required this.sections,
  });
}

// --- کلاس SeedLoader ---
// این کلاس داده‌های اولیه چک‌لیست‌ها را فراهم می‌کند.

class SeedLoader {
  static final Uuid _uuid = Uuid(); // برای تولید IDهای منحصر به فرد

  // مجموعه تمامی چک‌لیست‌های موجود به صورت استاتیک
  static final List<ChecklistItem> _allChecklists = [
    // --- چک لیست فایرباکس (HSE-6-022V1.pdf) ---
    ChecklistItem(
      id: 'HSE-6-022',
      title: 'چک لیست فایرباکس',
      category: 'ایمنی فایرباکس',
      sections: [
        ChecklistSection(
          id: 'hse-6-022-firebox',
          title: 'فایرباکس',
          questions: [
            QuestionDefinition(id: 'hse-6-022-firebox-1', text: 'جعبه از نظر شکل ظاهری سالم است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-022-firebox-2', text: 'شیرفلکه سالم است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-022-firebox-3', text: 'کوپلینگ اتصال به سر شیلنگ فشارقوی دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-022-firebox-4', text: 'عملکرد قرقره درست است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-022-firebox-5', text: 'تست شیلنگ برزنتی بیست متری مورد قبول است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-022-firebox-6', text: 'خار قفلی کوپلینگ‌ها سالم است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-022-firebox-7', text: 'واشر آب‌بندی کوپلینگ دو سر آن را دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-022-firebox-8', text: 'قرقره از نظر شکل و کارکرد سالم است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-022-firebox-9', text: 'آچار مخصوص باز و بست کوپلینگ دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-022-firebox-10', text: 'کلید درب جعبه در محل خود قرار دارد؟', responseType: QuestionResponseType.yesNo),
          ],
        ),
      ],
    ),
    // --- چک لیست کنترل و ارزیابی ادواری HSE (HSE-6-027V0.pdf) ---
    ChecklistItem(
      id: 'HSE-6-027',
      title: 'چک لیست کنترل و ارزیابی ادواری HSE',
      category: 'کنترل و ارزیابی ادواری',
      sections: [
        ChecklistSection(
          id: 'hse-6-027-saloon-prod',
          title: 'سالن تولید',
          questions: [
            QuestionDefinition(id: 'hse-6-027-saloon-prod-1', text: 'جعبه کمکهای اولیه با تجهیزات استفاده در محل وجود دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-2', text: 'کارگران از تجهیزات حفاظت فردی استفاده میکنند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-3', text: 'نظم و نظافت سالن به خوبی انجام میشود؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-4', text: 'نظافت رختکن مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-5', text: 'نظافت سرویسهای بهداشتی مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-6', text: 'نظافت غذاخوری مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-7', text: 'شستشوی آبسردکنها و تانکهای آب آشامیدنی انجام شده است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-8', text: 'وضعیت دیوارها، کف، سقف و شیشه پنجرهها مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-9', text: 'جمعآوری و تفکیک زبالهها و ضایعات مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-10', text: 'کلیه قسمتهای انتقال نیرو مانند تسمه، چرخ دنده و غیره حفاظ مناسب دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-11', text: 'سیستم ایمنی و قطع کن اضطراری ماشین آلات به نحو موثر کار میکند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-12', text: 'شیلنگهای هوای فشرده سالم و دارای بست مناسب میباشند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-13', text: 'قبل از شروع به تعمیر و سرویسکاری ماشین آلات به طور مطمئنی متوقف میشوند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-14', text: 'ماشین آلات معیوب و یا در دست تعمیر با علایم هشداردهنده مشخص میشوند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-15', text: 'تجهیزات برقی مانند دریل و سنگ و غیره سالم و فاقد عیوب فنی و الکتریکی هستند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-16', text: 'مقابل تابلوهای برق کفپوش عایق نصب شده است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-17', text: 'درب تابلوهای برق بسته است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-18', text: 'کلیه کلید و پریزها سالم و بدون عیب هستند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-19', text: 'کابلهای برق سالم و بدون عیب هستند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-20', text: 'کلیه تجهیزات اطفای حریق کنترل ماهیانه شدهاند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-21', text: 'اطراف تجهیزات اعلام و اطفای حریق باز است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-22', text: 'درها و مسیرهای خروجی اضطراری مشخص شدهاند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-23', text: 'مقابل درها و مسیرهای خروجی اضطراری باز بوده و مسدود نشدهاند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-24', text: 'MSDS مواد تهیه شده و در دسترس قرار دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-25', text: 'از نشت و ریزش مواد شیمیایی بر روی زمین به نحو مناسب جلوگیری شده است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-26', text: 'محل نگهداری مواد شیمیایی دارای تهویه مناسب میباشد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-27', text: 'کلیه پرتگاهها و محلهای سقوط، حفاظ گذاری شدهاند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-saloon-prod-28', text: 'خطرات ایمنی، بهداشتی و زیست محیطی شناسایی شده و تحت کنترل میباشند؟', responseType: QuestionResponseType.yesNo),
          ],
        ),
        ChecklistSection(
          id: 'hse-6-027-warehouse',
          title: 'انبار',
          questions: [
            QuestionDefinition(id: 'hse-6-027-warehouse-1', text: 'انبار دارای خروجیهای اضطراری مناسب بوده و این خروجیها کاملا باز است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-2', text: 'آراستگی در محل انبار رعایت شده و از ریخت و پاش مواد اجتناب شده است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-3', text: 'اطراف ساختمان انبار از خار و خاشاک و یا مواد قابل اشتعال پاکسازی شده است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-4', text: 'تجهیزات اطفای حریق کنترل ماهیانه شده است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-5', text: 'کلیه کلید و پریزها و کابلها سالم و بدون زدگی میباشد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-6', text: 'کابلها از داخل لولههای فلزی عبور کرده و یا از نوع حفاظدار میباشند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-7', text: 'لامپها و سیستم روشنایی از نوع ایمن بوده و فاصله ایمنی از مواد قابل اشتعال دارند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-8', text: 'MSDS مواد تهیه، نصب و آموزش داده شده است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-9', text: 'تاریخ انقضای مواد فاسد شدنی مورد توجه قرار میگیرد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-10', text: 'مواد بر اساس زمان تولید مصرف میشوند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-11', text: 'چیدمان کالا و بستههای مواد و قطعات مناسب و ایمن میباشد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-12', text: 'آیا از نشتی روغنها و سایر مواد شیمیایی جلوگیری میگردد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-13', text: 'کلیه پرتگاهها و محلهای سقوط حفاظ گذاری شدهاند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-warehouse-14', text: 'خطرات ایمنی، بهداشتی و زیست محیطی شناسایی شده و تحت کنترل میباشند؟', responseType: QuestionResponseType.yesNo),
          ],
        ),
        ChecklistSection(
          id: 'hse-6-027-welding-workshop',
          title: 'کارگاه جوشکاری',
          questions: [
            QuestionDefinition(id: 'hse-6-027-welding-workshop-1', text: 'جعبه کمکهای اولیه با تجهیزات لازم در محل وجود دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-2', text: 'نیروهای کارگاه جوشکاری از تجهیزات حفاظت فردی استفاده میکنند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-3', text: 'نظم و نظافت کارگاه به خوبی انجام میشود؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-4', text: 'جمعآوری و تفکیک زبالهها و ضایعات مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-5', text: 'کلیه قسمتهای انتقال نیرو دارای حفاظ مناسب میباشند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-6', text: 'کلیه کلید و پریزها سالم و بدون عیب هستند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-7', text: 'کابلهای برق سالم و بدون عیب هستند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-8', text: 'شیلنگهای هوای فشرده سالم و دارای بست مناسب میباشند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-9', text: 'کارگاه دارای تهویه مناسب میباشد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-10', text: 'کلیه تجهیزات اطفای حریق کنترل ماهیانه شدهاند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-11', text: 'کلیه قسمتهای دستگاههای الکتریکی، به سیستم اتصال زمین مجهز میباشند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-12', text: 'شیرها، بستها و شیلنگهای متصل به سیلندرها سالم و ایمن هستند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-13', text: 'سیلندرهای گاز به صورت قائم و ایمن نگهداری و به کار برده میشوند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-welding-workshop-14', text: 'خطرات ایمنی، بهداشتی و زیست محیطی شناسایی شده و تحت کنترل میباشند؟', responseType: QuestionResponseType.yesNo),
          ],
        ),
        ChecklistSection(
          id: 'hse-6-027-facilities-workshop',
          title: 'کارگاه تاسیسات',
          questions: [
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-1', text: 'جعبه کمکهای اولیه با تجهیزات لازم در محل وجود دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-2', text: 'کارگران از تجهیزات حفاظت فردی استفاده میکنند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-3', text: 'نظم و نظافت کارگاه به خوبی انجام میشود؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-4', text: 'جمعآوری و تفکیک زبالهها و ضایعات مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-5', text: 'از نشت و ریزش مواد شیمیایی و روغنهای سوخته و مصرفی جلوگیری میشود؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-6', text: 'کلیه قسمتهای انتقال نیرو دارای حفاظ مناسب میباشند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-7', text: 'کلیه کلید و پریزها سالم و بدون عیب هستند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-8', text: 'کابلهای برق سالم و بدون عیب هستند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-9', text: 'شیلنگهای هوای فشرده سالم و دارای بست مناسب میباشند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-10', text: 'کلیه تجهیزات اطفای حریق کنترل ماهیانه شدهاند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-11', text: 'درب تابلوهای برق بسته است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-12', text: 'مقابل تابلوهای برق کفپوش عایق نصب شده است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-13', text: 'کلیه قسمتهای دستگاههای الکتریکی، به سیستم اتصال زمین مجهز میباشند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-14', text: 'سرویس و نگهداری دیگهای بخار و آب جوش طبق برنامه انجام میشود؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-15', text: 'سرویس و نگهداری پمپهای آب طبق برنامه انجام میشود؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-16', text: 'تست هیدرواستاتیک سالیانه دیگهای بخار و آب جوش انجام میشود؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-17', text: 'تست ضخامت سنجی بدنه دیگهای بخار و آب جوش در بازرسی سالیانه انجام میشود؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-18', text: 'فشارسنجها (مانومترها) سالیانه یکبار کالیبره میشوند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-19', text: 'MSDS مواد تهیه شده و در دسترس قرار دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-20', text: 'خطرات ایمنی، بهداشتی و زیست محیطی شناسایی شده و تحت کنترل میباشند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-facilities-workshop-21', text: 'علایم ایمنی متناسب با خطرات محیط کار نصب شده است؟', responseType: QuestionResponseType.yesNo),
          ],
        ),
        ChecklistSection(
          id: 'hse-6-027-restaurant',
          title: 'رستوران',
          questions: [
            QuestionDefinition(id: 'hse-6-027-restaurant-1', text: 'کلیه پرسنل دارای کارت سلامت میباشند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-2', text: 'پرسنل آشپزخانه، نظافت فردی را رعایت مینمایند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-3', text: 'پرسنل از کلاه، لباسکار و دستکش استفاده میکنند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-4', text: 'نظم و نظافت محیط آشپزخانه و رستوران به خوبی انجام میشود؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-5', text: 'جعبه کمکهای اولیه با تجهیزات لازم در محل وجود دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-6', text: 'وضعیت ظروف پخت و پز و سرو غذا مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-7', text: 'نحوه نگهداری مواد غذایی مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-8', text: 'تاریخ مصرف مواد غذایی رعایت میشود؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-9', text: 'وضعیت ظرفشوییها و کانالهای آبرو مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-10', text: 'طوری دربها و پنجرهها سالم است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-11', text: 'وضعیت دیوارها کف، سقف و شیشه پنجرهها مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-12', text: 'شیرآلات و اتصالات آب و گاز سالم بوده و نشتی ندارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-13', text: 'جمعآوری و تفکیک زبالهها و ضایعات مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-14', text: 'کلیه کلید و پریزها سالم و بدون عیب هستند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-15', text: 'کابلهای برق سالم و بدون عیب هستند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-16', text: 'تجهیزات اطفای حریق کنترل ماهیانه شدهاند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-17', text: 'MSDS مواد تهیه شده و در دسترس قرار دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-restaurant-18', text: 'خطرات ایمنی، بهداشتی و زیست محیطی شناسایی شده و تحت کنترل میباشند؟', responseType: QuestionResponseType.yesNo),
          ],
        ),
        ChecklistSection(
          id: 'hse-6-027-compound',
          title: 'محوطه',
          questions: [
            QuestionDefinition(id: 'hse-6-027-compound-1', text: 'وضعیت خروجی آبراههای سطحی مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-compound-2', text: 'وضعیت محل و نحوه نگهداری کپسولهای گاز مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-compound-3', text: 'وضعیت نگهداری بشکههای بنزین مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-compound-4', text: 'وضعیت محل نگهداری مخازن گازوئیل مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-compound-5', text: 'نگهداری، تفکیک و نگهداری زبالهها و ضایعات مختلف کارخانه مناسب است', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-compound-6', text: 'نگهداری فضای سبز مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-compound-7', text: 'نظم و نظافت محوطه کارخانه مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-compound-8', text: 'خطرات ایمنی، بهداشتی و زیست محیطی شناسایی شده و تحت کنترل میباشند؟', responseType: QuestionResponseType.yesNo),
          ],
        ),
        ChecklistSection(
          id: 'hse-6-027-forklift',
          title: 'لیفتراک',
          questions: [
            QuestionDefinition(id: 'hse-6-027-forklift-1', text: 'آیا لیفتراک مجهز به کپسول اطفاء حریق است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-forklift-2', text: 'آیا شاخکهای لیفتراک سالم و بدون نقص است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-forklift-3', text: 'آیا چراغهای جلو و عقب لیفتراک سالم است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-forklift-4', text: 'آیا آژیر دنده عقب لیفتراک سالم و در حین کار عمل میکند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-forklift-5', text: 'آیا وضعیت لاستیکها، چرخها و بدنه لیفتراک سالم است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-forklift-6', text: 'آیا آینههای لیفتراک سالم است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-forklift-7', text: 'آیا صندلی سالم و فاقد شکستگی است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-forklift-8', text: 'آیا بست نگهدارنده سیلندر سوخت و کپسول اطفای حریق سالم است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-forklift-9', text: 'آیا اتصالات شیلنگ روغن لیفتراک سالم و بدون نشتی و روغنریزی است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-forklift-10', text: 'آیا ترمز، فرمان و دستگاههای کنترلی لیفتراک سالم است و درست کار میکند؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-027-forklift-11', text: 'آیا کابین لیفتراک مسقف است؟', responseType: QuestionResponseType.yesNo),
          ],
        ),
      ],
    ),
    // --- چک لیست ایمنی برق (HSE-6-028V0.pdf) ---
    ChecklistItem(
      id: 'HSE-6-028',
      title: 'چک لیست ایمنی برق',
      category: 'ایمنی برق',
      sections: [
        ChecklistSection(
          id: 'hse-6-028-general-safety',
          title: 'ایمنی برق عمومی',
          questions: [
            QuestionDefinition(id: 'hse-6-028-general-safety-1', text: 'آیا کلیه وسایل الکتریکی و ادوات برقی مثل کلیدها، پریزها و غیره سالم هستند؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-2', text: 'آیا سیم‌کشی مطابق اصول فنی می‌باشد؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-3', text: 'آیا سیم‌کشی غیر مجاز وجود دارد؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-4', text: 'آیا سیم‌ها از داخل لوله‌های عایق یا سینی برق عبور داده شده‌اند؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-5', text: 'آیا سر راه جریان برق دستگاه‌ها، فیوز سالم و متناسب قرار دارد؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-6', text: 'آیا هنگام تعمیرات از ابزار و وسایل ایمنی عایق استفاده می‌شود؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-7', text: 'آیا تعمیرات برق توسط افراد مسئول و متخصص انجام می‌شود؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-8', text: 'آیا هنگام تعمیرات دستگاه‌های برقی، فیوزهای تابلو برق مربوط به دستگاه برداشته می‌شود و تابلو "دست نزنید" نصب می‌شود؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-9', text: 'آیا کابل‌های دستگاه الکتریکی از کابل‌های دستگاه‌های خبرکننده مانند کاشف‌ها (detector) جدا می‌باشد؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-10', text: 'آیا نکات ایمنی در خصوص سیم‌های سیار رعایت می‌شود؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-11', text: 'آیا از وسایل حفاظت فردی مناسب در هنگام کار با وسایل برقی استفاده می‌شود؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-12', text: 'آیا کارگران برق‌کار، آموزش‌های لازم در مورد ایمنی برق و کمک‌های اولیه را دیده‌اند؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-13', text: 'آیا سیستم اتصال به زمین، چاه ارت و دستگاه ارت وجود دارد؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-14', text: 'آیا تمام دستگاه‌ها و زمین به صورت دوره‌ای سیستم ارت متصل هستند و سیم اتصال به زمین به صورت دوره‌ای چک می‌شود؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-15', text: 'آیا مقاومت چاه ارت به صورت دوره‌ای ارزیابی می‌گیرد؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-16', text: 'آیا نکات ایمنی در هنگام کار در مکان‌های مرطوب رعایت می‌گردد؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-17', text: 'آیا قبل از استفاده از وسایل و ابزارآلات برقی، کنترل ایمنی آن‌ها صورت می‌گیرد؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-18', text: 'آیا قبل از استفاده از وسایل برقی ولتاژ آن کنترل می‌شود؟ (آیا تمام دستگاه‌ها نشانگر ولتاژ دارند)', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-19', text: 'آیا سیستم برق‌گیر نصب شده است و کارگاه را به صورت مناسب تحت پوشش قرار می‌دهد؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-20', text: 'آیا نگهداری تجهیزات الکتریکی نصب شده به صورت دوره‌ای صورت می‌گیرد؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-21', text: 'آیا کلیدهای الکتریکی دستگاه‌ها برچسب‌های مناسب شناسایی دارند؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-22', text: 'آیا دستورالعمل‌های مناسب ایمنی برق وجود دارد و رعایت می‌گردد؟', responseType: QuestionResponseType.yesNoPartialNA),
            QuestionDefinition(id: 'hse-6-028-general-safety-23', text: 'آیا آموزش‌های لازم در خصوص ایمنی برق و کمک‌های اولیه در هنگام برق‌گرفتگی داده شده است؟', responseType: QuestionResponseType.yesNoPartialNA),
          ],
        ),
        ChecklistSection(
          id: 'hse-6-028-switchgear-safety',
          title: 'ایمنی تابلوهای برق',
          questions: [
            QuestionDefinition(id: 'hse-6-028-switchgear-safety-24', text: 'تابلوهای برق سالم می‌باشد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-028-switchgear-safety-25', text: 'محل قرارگرفتن تابلوهای برق مناسب است؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-028-switchgear-safety-26', text: 'تابلوهای برق در محفظه قفل‌دار مخصوص قرار دارد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-028-switchgear-safety-27', text: 'تابلو برق در اختیار فرد مسئول و مورد بازرسی مستمر می‌باشد؟', responseType: QuestionResponseType.yesNo),
            QuestionDefinition(id: 'hse-6-028-switchgear-safety-28', te
