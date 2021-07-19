module c3quake;
import std::cinterop;

struct Link
{
    Link *prev;
    Link *next;
}

char[1024] com_token @extname("com_token");

extern func int printf(char *, ...);

func void Link.clear(Link *link) @extname("ClearLink")
{
    link.prev = link.next = link;
}

func void Link.remove(Link *link) @extname("RemoveLink")
{
    link.next.prev = link.prev;
    link.prev.next = link.next;
}

func void Link.insertBefore(Link *link, Link *before) @extname("InsertLinkBefore")
{
    link.next = before;
    link.prev = before.prev;
    link.prev.next = link.next.prev = link;
}

func void Link.insertAfter(Link *link, Link *after) @extname("InsertLinkAfter")
{
    link.next = after.next;
    link.prev = after;
    link.prev.next = link;
    link.next.prev = link;
}

func bool is_upper(int c) @inline
{
	return c >= 'A' && c <= 'Z';
}

func bool is_lower(int c) @inline
{
	return c >= 'a' && c <= 'z';
}

func char to_lower(char c) @inline
{
	return is_upper(c) ? (c | ('a' - 'A')) : c;
}

func char to_upper(char c) @inline
{
	return is_lower(c) ? (c & ~(char)('a' - 'A')) : c;
}

func CInt strcasecmp(char* s1, char* s2) @extname("q_strcasecmp")
{
	char* p1 = s1;
	char* p2 = s2;

	if (p1 == p2) return 0;

	char c1 = void;
	char c2 = void;
	do
	{
		c1 = to_lower(*p1++);
		c2 = to_lower(*p2++);
		if (c1 == '\0') break;
	} while (c1 == c2);

	return (CInt)(c1 - c2);
}

func CInt strncasecmp(char* s1, char* s2, usize n) @extname("q_strncasecmp")
{
	char* p1 = s1;
	char* p2 = s2;

	if (p1 == p2 || n == 0) return 0;

	char c1 = void;
	char c2 = void;
	do
	{
		c1 = to_lower(*p1++);
		c2 = to_lower(*p2++);
		if (c1 == '\0' || c1 != c2) break;
	} while (--n > 0);

	return (CInt)(c1 - c2);
}


func char* str_to_lower(char* str) @extname("q_strlwr")
{
	char* c = str;
	while (*c)
	{
		*c = to_lower(*c);
		c++;
	}
	return str;
}

func char* str_to_upper(char* str)  @extname("q_strupr")
{
	char* c = str;
	while (*c)
	{
		*c = to_upper(*c);
		c++;
	}
	return str;
}