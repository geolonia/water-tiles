delete from metadata where name in (
  'generator',
  'generator_options',
  'filesize'
);
