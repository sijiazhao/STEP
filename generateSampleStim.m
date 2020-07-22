design.num_seg_pre=40;
design.num_seg_post=40;
design.notedur = 50;
design.fs=44100;

type='STEP';
fgen_STEP(type,design.fs,design.notedur);

type='noSTEP';
fgen_STEP(type,design.fs,design.notedur);