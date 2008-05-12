package File::Lockfile;

require Class::Data::Inheritable;
use base qw(Class::Data::Inheritable);

__PACKAGE__->mk_classdata(qw/lock_key/);

sub new {
	my ($class, $lock_key, $dir) = @_;
	$class->lock_key($dir.'/'.$lock_key.'.lck');	
	return bless {},$class;
}

sub write {
	my $fh;
	open $fh, '>', __PACKAGE__->lock_key;
	print $fh $$;
}

sub remove {
	unlink __PACKAGE__->lock_key;	
}

sub check {
	my ($class, $lock_key) = @_;
	
	$lock_key = __PACKAGE__->lock_key unless $lock_key;
	
	if ( -s  $lock_key ) {
		my $fh;
		open $fh, '<', $lock_key;
		my $pid = <$fh>;
		return $pid; 
	}
	return 0;
}

1;