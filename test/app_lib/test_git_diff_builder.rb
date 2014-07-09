  test 'chunk with a space in its filename' do
    @diff_lines =
    ]

    @source_lines =
    ]
    @expected =
    assert_equal_builder
  test 'chunk with defaulted now line info' do
    @diff_lines =
    ]

    @source_lines =
    ]
    @expected =
    assert_equal_builder
  test 'two chunks with leading and trailing same lines ' +
    @diff_lines =
    ]

    @source_lines =
    ]
    @expected =
    assert_equal_builder
  test 'diffs 7 lines apart are not merged ' +
       'into contiguous sections in one chunk' do
    @diff_lines =
    ]

    @source_lines =
    ]
    @expected =
    assert_equal_builder
  test 'one chunk with two sections ' +
    @diff_lines =
    ]

    @source_lines =
    ]
    @expected =
    assert_equal_builder
  test 'one chunk with one section with only lines added' do
    @diff_lines =
      ' bbb',
      ' ccc',
      '+ddd',
      '+eee',
      '+fff',
      ' ggg',
      ' hhh',
      ' iii'
    ]

    @source_lines =
      'bbb',
      'ccc',
      'ddd',
      'eee',
      'fff',
      'ggg',
      'hhh',
      'iii',
      'jjj'
    ]
    @expected =
      same_line('bbb', 2),
      same_line('ccc', 3),
      added_line('ddd', 4),
      added_line('eee', 5),
      added_line('fff', 6),
      same_line('ggg', 7),
      same_line('hhh', 8),
      same_line('iii', 9),
      same_line('jjj', 10)
    assert_equal_builder
  test 'one chunk with one section with only lines deleted' do
    @diff_lines =
    ]

    @source_lines =
    ]
    @expected =
    assert_equal_builder
  test 'one chunk with one section ' +
    @diff_lines =
      ' ddd',
      ' eee',
      ' fff',
      '-ggg',
      '-hhh',
      '-iii',
      '+jjj',
      ' kkk',
      ' lll',
      ' mmm'
    ]
    @source_lines =
    [
      'bbb',
      'ccc',
      'ddd',
      'eee',
      'fff',
      'jjj',
      'kkk',
      'lll',
      'mmm',
      'nnn'
    ]
    @expected =
      same_line('bbb', 1),
      same_line('ccc', 2),
      same_line('ddd', 3),
      same_line('eee', 4),
      same_line('fff', 5),
      deleted_line('ggg', 6),
      deleted_line('hhh', 7),
      deleted_line('iii', 8),
      added_line('jjj', 6),
      same_line('kkk', 7),
      same_line('lll', 8),
      same_line('mmm', 9),
      same_line('nnn', 10)
    assert_equal_builder
  test 'one chunk with one section ' +
    @diff_lines =
    ]

    @source_lines =
    ]
    @expected =
    assert_equal_builder
  test 'one chunk with one section ' +
    @diff_lines =
    ]

    @source_lines =
    @expected =
    assert_equal_builder
  def assert_equal_builder
    diff = GitDiff::GitDiffParser.new(@diff_lines.join("\n")).parse_one
    builder = GitDiff::GitDiffBuilder.new()
    actual = builder.build(diff, @source_lines)
    assert_equal @expected, actual