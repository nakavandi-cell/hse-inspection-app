class ChecklistSection {
  final String id;
  final String title;
  final List<String> questions;

  const ChecklistSection({
    required this.id,
    required this.title,
    required this.questions,
  });
}

class ChecklistItem {
  final String id;
  final String title;
  final String code;
  final String category;
  final List<ChecklistSection> sections;

  const ChecklistItem({
    required this.id,
    required this.title,
    required this.code,
    required this.category,
    required this.sections,
  });
}

class SeedLoader {
  static final List<ChecklistItem> allChecklists = [
    const ChecklistItem(
      id: 'elec_gen_01',
      title: 'چک‌لیست ایمنی برق عمومی',
      code: 'HSE-EL-01',
      category: 'ایمنی برق',
      sections: [
        ChecklistSection(
          id: 'sec_eg1',
          title: 'بررسی سیم‌کشی و اتصالات عمومی',
          questions: [
            'آیا کابل‌ها و سیم‌های روکار فاقد هرگونه فرسودگی و آسیب فیزیکی هستند؟',
            'آیا اتصالات از طریق ترمینال استاندارد انجام شده و چسب‌برق غیراستاندارد وجود ندارد؟',
            'آیا پریزها، کلیدها و سرپیچ‌های روشنایی سالم و دارای درپوش محافظ هستند؟',
            'آیا سیستم ارتینگ به تمام پریزها و مصرف‌کننده‌ها متصل است؟',
          ],
        ),
      ],
    ),
    const ChecklistItem(
      id: 'elec_pnl_02',
      title: 'چک‌لیست ایمنی تابلوهای توزیع برق',
      code: 'HSE-EL-02',
      category: 'ایمنی برق',
      sections: [
        ChecklistSection(
          id: 'sec_ep1',
          title: 'وضعیت فیزیکی و حفاظتی تابلو',
          questions: [
            'آیا درب تابلو برق قفل بوده و کلید آن در دسترس افراد مسئول است؟',
            'آیا علامت هشدار خطر برق‌گرفتگی روی درب تابلو نصب شده است؟',
            'آیا لاستیک عایق برق استاندارد جلوی تابلو پهن است؟',
            'آیا دیاگرام تک‌خطی و شماره‌گذاری فیوزها و کلیدها مشخص است؟',
            'آیا شینه‌های فاز، نول و ارت تفکیک شده و دارای روکش عایق هستند؟',
          ],
        ),
      ],
    ),
    const ChecklistItem(
      id: 'elec_sub_03',
      title: 'چک‌لیست ایمنی پست‌های برق',
      code: 'HSE-EL-03',
      category: 'ایمنی برق',
      sections: [
        ChecklistSection(
          id: 'sec_es1',
          title: 'ایمنی محیطی و تجهیزات پست برق',
          questions: [
            'آیا سیستم تهویه و کنترل دمای اتاق پست برق به‌درستی عمل می‌کند؟',
            'آیا تجهیزات اطفای حریق مناسب پست برق مستقر هستند؟',
            'آیا سیستم روشنایی اضطراری اتاق پست فعال و آماده‌به‌کار است؟',
            'آیا چاه ارت اصلی پست و رینگ اتصال زمین دوره‌ای تست شده است؟',
            'آیا ترانسفورماتورها فاقد نشتی روغن یا صدای غیرعادی هستند؟',
          ],
        ),
      ],
    ),
    const ChecklistItem(
      id: 'elec_prt_04',
      title: 'چک‌لیست ایمنی وسایل و ابزار برقی پرتابل',
      code: 'HSE-EL-04',
      category: 'ایمنی برق',
      sections: [
        ChecklistSection(
          id: 'sec_epr1',
          title: 'ایمنی ابزارها و کابل‌های سیار',
          questions: [
            'آیا کابل رابط و دوشاخه ابزار فاقد زدگی، دوپوستی و ترمیم غیراصولی است؟',
            'آیا حفاظ‌های فیزیکی سنگ‌فرز، دریل و سایر ابزارهای دوار نصب هستند؟',
            'آیا تابلوی برق سیار مجهز به کلید محافظ جان سالم است؟',
            'آیا برچسب کالیبراسیون و تأییدیه بازرسی دوره‌ای روی ابزار الصاق شده است؟',
          ],
        ),
      ],
    ),
    const ChecklistItem(
      id: 'fire_ext_01',
      title: 'چک‌لیست بازرسی خاموش‌کننده‌های دستی',
      code: 'HSE-FR-01',
      category: 'اعلام و اطفای حریق',
      sections: [
        ChecklistSection(
          id: 'sec_fe1',
          title: 'کنترل فیزیکی و عملکردی کپسول‌ها',
          questions: [
            'آیا کپسول در محل تعیین‌شده نصب و مسیر دسترسی به آن آزاد است؟',
            'آیا عقربه گیج فشار در محدوده سبز قرار دارد؟',
            'آیا ضامن، پلمپ و کارت شارژ سالیانه معتبر هستند؟',
            'آیا شیلنگ، نازل و بدنه کپسول فاقد پوسیدگی یا خوردگی هستند؟',
          ],
        ),
      ],
    ),
    const ChecklistItem(
      id: 'fire_box_02',
      title: 'چک‌لیست بازرسی جعبه‌های آتش‌نشانی',
      code: 'HSE-FR-02',
      category: 'اعلام و اطفای حریق',
      sections: [
        ChecklistSection(
          id: 'sec_fb1',
          title: 'وضعیت جعبه و اتصالات فایرباکس',
          questions: [
            'آیا درب جعبه به‌آسانی باز شده و شیشه آن سالم است؟',
            'آیا شیلنگ یا قرقره هوزریل سالم است؟',
            'آیا نازل، کوپلینگ و آچار هیدرانت داخل جعبه موجود است؟',
            'آیا شیر فلکه اصلی فاقد نشتی آب است؟',
          ],
        ),
      ],
    ),
    const ChecklistItem(
      id: 'eq_fork_01',
      title: 'چک‌لیست بازرسی ایمنی لیفتراک',
      code: 'HSE-EQ-01',
      category: 'ماشین‌آلات و تجهیزات',
      sections: [
        ChecklistSection(
          id: 'sec_fk1',
          title: 'سیستم‌های ایمنی و هیدرولیک لیفتراک',
          questions: [
            'آیا بوق دنده‌عقب، چراغ گردان و چراغ‌های روشنایی کار می‌کنند؟',
            'آیا ترمز پایی و ترمز دستی کارایی کامل دارند؟',
            'آیا شاخک‌ها، زنجیر دکل و جک‌های هیدرولیک فاقد ترک و نشتی هستند؟',
            'آیا کپسول آتش‌نشانی نصب‌شده روی لیفتراک سالم است؟',
            'آیا کمربند ایمنی و ساختار محافظ راننده سالم است؟',
          ],
        ),
      ],
    ),
    const ChecklistItem(
      id: 'gen_rest_01',
      title: 'چک‌لیست بهداشت و ایمنی رستوران و آشپزخانه',
      code: 'HSE-OH-01',
      category: 'بهداشت و محیط کار',
      sections: [
        ChecklistSection(
          id: 'sec_rst1',
          title: 'بهداشت فردی، محیطی و ایمنی پخت‌وپز',
          questions: [
            'آیا پرسنل آشپزخانه کارت بهداشت معتبر و لباس کار مناسب دارند؟',
            'آیا هود صنعتی و تهویه به‌درستی کار می‌کند؟',
            'آیا دمای یخچال‌ها و سردخانه‌ها کنترل و ثبت می‌شود؟',
            'آیا سیستم اطفای حریق مخصوص روغن و کپسول مناسب موجود است؟',
            'آیا کف و دیواره‌ها تمیز، ضدعفونی و عاری از لغزندگی هستند؟',
          ],
        ),
      ],
    ),
  ];

  static List<String> get categories {
    return allChecklists.map((item) => item.category).toSet().toList();
  }

  static List<ChecklistItem> getByCategory(String category) {
    return allChecklists
        .where((item) => item.category == category)
        .toList();
  }
}
