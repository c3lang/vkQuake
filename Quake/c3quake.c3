module c3quake;

struct Link
{
    Link* prev;
    Link* next;
}

char[1024] com_token @extern("com_token");

extern fn int printf(char *, ...);

fn void Link.clear(Link* link) @extern("ClearLink")
{
    link.prev = link.next = link;
}

fn void Link.remove(Link* link) @extern("RemoveLink")
{
    link.next.prev = link.prev;
    link.prev.next = link.next;
}

fn void Link.insertBefore(Link *link, Link *before) @extern("InsertLinkBefore")
{
    link.next = before;
    link.prev = before.prev;
    link.prev.next = link.next.prev = link;
}

fn void Link.insertAfter(Link *link, Link *after) @extern("InsertLinkAfter")
{
    link.next = after.next;
    link.prev = after;
    link.prev.next = link;
    link.next.prev = link;
}

fn bool is_upper(int c) @inline
{
	return c >= 'A' && c <= 'Z';
}

fn bool is_lower(int c) @inline
{
	return c >= 'a' && c <= 'z';
}

fn char to_lower(char c) @inline
{
	return is_upper(c) ? (c | ('a' - 'A')) : c;
}

fn char to_upper(char c) @inline
{
	return is_lower(c) ? (c & ~(char)('a' - 'A')) : c;
}

fn CInt strcasecmp(char* s1, char* s2) @extern("q_strcasecmp")
{
	if (s1 == s2) return 0;

	char c1 @noinit;
	char c2 @noinit;
	do
	{
		c1 = to_lower(*s1++);
		c2 = to_lower(*s2++);
		if (c1 == '\0') break;
	} while (c1 == c2);

	return (CInt)(c1 - c2);
}

fn CInt strncasecmp(char* s1, char* s2, usz n) @extern("q_strncasecmp")
{
	if (s1 == s2 || n == 0) return 0;

	char c1 @noinit;
	char c2 @noinit;
	do
	{
		c1 = to_lower(*s1++);
		c2 = to_lower(*s2++);
		if (c1 == '\0' || c1 != c2) break;
	} while (--n > 0);

	return (CInt)(c1 - c2);
}


fn char* str_to_lower(char* str) @extern("q_strlwr")
{
	char* c = str;
	while (*c)
	{
		*c = to_lower(*c);
		c++;
	}
	return str;
}

fn char* str_to_upper(char* str)  @extern("q_strupr")
{
	char* c = str;
	while (*c)
	{
		*c = to_upper(*c);
		c++;
	}
	return str;
}
